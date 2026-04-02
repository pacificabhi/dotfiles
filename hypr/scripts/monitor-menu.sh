#!/bin/bash
# monitor-menu.sh — Interactive monitor configuration via wofi
# Changes apply live. Use "Save" to persist to monitors.conf.

WOFI_ARGS=(--dmenu --insensitive --no-actions)

pick() {
    local prompt="$1"; shift
    printf '%s\n' "$@" | wofi "${WOFI_ARGS[@]}" --prompt "$prompt"
}

# ── data helpers ──────────────────────────────────────────────────────────────

mons_json() { hyprctl monitors all -j; }

mon_field() {
    # mon_field <name> <jq-expr>
    mons_json | jq -r --arg n "$1" ".[] | select(.name==\$n) | $2"
}

cur_mode() {
    local name="$1" w h
    w=$(mon_field "$name" '.width')
    h=$(mon_field "$name" '.height')
    mons_json | jq -r --arg n "$name" --arg w "$w" --arg h "$h" \
        '.[] | select(.name==$n) | .availableModes[] | select(startswith($w+"x"+$h+"@"))' | head -1
}

cur_pos()   { mon_field "$1" '"\(.x)x\(.y)"'; }
cur_scale() { mon_field "$1" '.scale'; }

# ── workspace assignment state (source of truth for all 10 workspaces) ────────

declare -A WS_ASSIGN      # WS_ASSIGN[N]   = monitor_name
declare -A MON_WALLPAPER  # MON_WALLPAPER[name] = /absolute/path

init_ws_assign() {
    local default_mon
    default_mon=$(mons_json | jq -r '.[0].name')

    # 1. Default all 10 to the first monitor
    for i in $(seq 1 10); do
        WS_ASSIGN[$i]="$default_mon"
    done

    # 2. Override with saved rules from monitors.conf (covers unvisited workspaces)
    if [[ -f ~/.config/hypr/monitors.conf ]]; then
        while IFS= read -r line; do
            if [[ "$line" =~ ^workspace=([0-9]+),monitor:(.+)$ ]]; then
                WS_ASSIGN[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]}"
            fi
        done < ~/.config/hypr/monitors.conf
    fi

    # 3. Override with live data for workspaces that actually exist
    while IFS='=' read -r ws mon; do
        [[ -n "$ws" && -n "$mon" ]] && WS_ASSIGN[$ws]="$mon"
    done < <(hyprctl workspaces -j | jq -r '.[] | "\(.id)=\(.monitor)"')
}

mon_workspaces() {
    # space-separated workspace ids assigned to a monitor (from WS_ASSIGN)
    local mon="$1" result=()
    for ws in $(seq 1 10); do
        [[ "${WS_ASSIGN[$ws]}" == "$mon" ]] && result+=("$ws")
    done
    echo "${result[*]}"
}

# ── wallpaper state ───────────────────────────────────────────────────────────

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

init_mon_wallpaper() {
    local default_path="$WALLPAPER_DIR/wall.jpg"

    # Parse hyprpaper.conf: resolve $var definitions, then read wallpaper blocks
    declare -A hp_vars
    local cur_mon=""
    while IFS= read -r line; do
        local stripped="${line#"${line%%[![:space:]]*}"}"  # ltrim
        # Variable definition: $name = value
        if [[ "$stripped" =~ ^\$([a-zA-Z_]+)[[:space:]]*=[[:space:]]*(.+)$ ]]; then
            local var="${BASH_REMATCH[1]}" val="${BASH_REMATCH[2]}"
            val="${val/\$HOME/$HOME}"
            for k in "${!hp_vars[@]}"; do val="${val/\$$k/${hp_vars[$k]}}"; done
            hp_vars[$var]="$val"
        elif [[ "${stripped//[[:space:]]}" == "monitor="* ]]; then
            cur_mon="${stripped#*monitor=}"
            cur_mon="${cur_mon//[[:space:]]}"
        elif [[ "${stripped//[[:space:]]}" == "path="* ]]; then
            local path="${stripped#*path=}"
            path="${path//[[:space:]]}"
            path="${path/\$HOME/$HOME}"
            for k in "${!hp_vars[@]}"; do path="${path/\$$k/${hp_vars[$k]}}"; done
            [[ -n "$cur_mon" ]] && MON_WALLPAPER[$cur_mon]="$path"
            cur_mon=""
        fi
    done < "$HYPRPAPER_CONF"

    # Use parsed $wallpath as fallback default if available
    [[ -n "${hp_vars[wallpath]}" ]] && default_path="${hp_vars[wallpath]}"

    # Fill any monitors not found in conf
    mapfile -t _names < <(mons_json | jq -r '.[].name')
    for mon in "${_names[@]}"; do
        [[ -z "${MON_WALLPAPER[$mon]}" ]] && MON_WALLPAPER[$mon]="$default_path"
    done
}

apply_wallpaper() {
    # apply_wallpaper <monitor> <path>  — live via hyprpaper IPC
    local mon="$1" path="$2"
    [[ -f "$path" ]] || return
    MON_WALLPAPER[$mon]="$path"
    hyprctl hyprpaper preload "$path" &>/dev/null
    hyprctl hyprpaper wallpaper "$mon,$path" &>/dev/null
}

menu_wallpaper() {
    local mon="$1"
    mapfile -t files < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -printf '%f\n' | sort)
    [[ ${#files[@]} -eq 0 ]] && return

    local current_file="${MON_WALLPAPER[$mon]##*/}"
    local options=()
    for f in "${files[@]}"; do
        if [[ "$f" == "$current_file" ]]; then
            options+=("● $f  ← current")
        else
            options+=("  $f")
        fi
    done

    local choice
    choice=$(pick "Wallpaper — $mon" "${options[@]}") || return
    [[ -z "$choice" ]] && return
    choice=$(echo "$choice" | sed 's/^[● ] //; s/  ← current//')

    apply_wallpaper "$mon" "$WALLPAPER_DIR/$choice"
}

menu_wallpaper_all() {
    mapfile -t files < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -printf '%f\n' | sort)
    [[ ${#files[@]} -eq 0 ]] && return

    local choice
    choice=$(pick "Wallpaper — all monitors" "${files[@]/#/  }") || return
    [[ -z "$choice" ]] && return
    choice="${choice#  }"

    mapfile -t mon_names < <(mons_json | jq -r '.[].name')
    for mon in "${mon_names[@]}"; do
        apply_wallpaper "$mon" "$WALLPAPER_DIR/$choice"
    done
}

# ── apply helpers ─────────────────────────────────────────────────────────────

apply_monitor_keyword() {
    # apply_monitor_keyword <name> <mode_no_hz> <pos> <scale>
    # mode_no_hz: e.g. "2560x1440@74.97"
    hyprctl keyword monitor "$1,$2,$3,$4"
}

move_workspaces() {
    local mon="$1"; shift
    for ws in $@; do
        hyprctl dispatch moveworkspacetomonitor "$ws $mon" &>/dev/null
    done
}

# ── resolution menu ───────────────────────────────────────────────────────────

menu_resolution() {
    local mon="$1"
    local current
    current=$(cur_mode "$mon")

    mapfile -t modes < <(mon_field "$mon" '.availableModes[]')

    local options=()
    for m in "${modes[@]}"; do
        if [[ "$m" == "$current" ]]; then
            options+=("● $m  ← current")
        else
            options+=("  $m")
        fi
    done

    local choice
    choice=$(pick "Resolution — $mon" "${options[@]}") || return
    [[ -z "$choice" ]] && return

    # Strip marker and trailing " ← current", then strip Hz
    choice=$(echo "$choice" | sed 's/^[● ] //; s/  ← current//')
    local mode_no_hz="${choice%Hz}"

    apply_monitor_keyword "$mon" "$mode_no_hz" "$(cur_pos "$mon")" "$(cur_scale "$mon")"
}

# ── position menu ─────────────────────────────────────────────────────────────

menu_position() {
    local mon="$1"
    local mons
    mons=$(mons_json)

    mapfile -t others < <(echo "$mons" | jq -r --arg n "$mon" '.[] | select(.name!=$n) | .name')

    local options=("Custom x,y")
    for o in "${others[@]}"; do
        options+=("Right of $o" "Left of $o" "Below $o" "Above $o")
    done

    local choice
    choice=$(pick "Position — $mon" "${options[@]}") || return
    [[ -z "$choice" ]] && return

    local new_x new_y
    local cur_w cur_h
    cur_w=$(echo "$mons" | jq -r --arg n "$mon" '.[] | select(.name==$n) | .width')
    cur_h=$(echo "$mons" | jq -r --arg n "$mon" '.[] | select(.name==$n) | .height')

    if [[ "$choice" == "Custom x,y" ]]; then
        local input
        input=$(echo "" | wofi "${WOFI_ARGS[@]}" --prompt "Enter position as x,y (e.g. 1920,0)") || return
        [[ -z "$input" ]] && return
        new_x="${input%%,*}"
        new_y="${input##*,}"
    else
        local rel="${choice##* }"     # last word = monitor name
        local rel_x rel_y rel_w rel_h
        rel_x=$(echo "$mons" | jq -r --arg n "$rel" '.[] | select(.name==$n) | .x')
        rel_y=$(echo "$mons" | jq -r --arg n "$rel" '.[] | select(.name==$n) | .y')
        rel_w=$(echo "$mons" | jq -r --arg n "$rel" '.[] | select(.name==$n) | .width')
        rel_h=$(echo "$mons" | jq -r --arg n "$rel" '.[] | select(.name==$n) | .height')

        case "$choice" in
            "Right of"*) new_x=$((rel_x + rel_w));    new_y=$rel_y ;;
            "Left of"*)  new_x=$((rel_x - cur_w));    new_y=$rel_y ;;
            "Below"*)    new_x=$rel_x;                new_y=$((rel_y + rel_h)) ;;
            "Above"*)    new_x=$rel_x;                new_y=$((rel_y - cur_h)) ;;
        esac
    fi

    apply_monitor_keyword "$mon" "$(cur_mode "$mon" | sed 's/Hz$//')" "${new_x}x${new_y}" "$(cur_scale "$mon")"
}

# ── scale menu ────────────────────────────────────────────────────────────────

menu_scale() {
    local mon="$1"
    local current
    current=$(cur_scale "$mon")

    local options=()
    for s in 0.5 0.75 1.0 1.25 1.5 1.75 2.0; do
        if (( $(echo "$s == $current" | bc -l) )); then
            options+=("● $s  ← current")
        else
            options+=("  $s")
        fi
    done

    local choice
    choice=$(pick "Scale — $mon" "${options[@]}") || return
    [[ -z "$choice" ]] && return
    choice=$(echo "$choice" | sed 's/^[● ] //; s/  ← current//')

    apply_monitor_keyword "$mon" "$(cur_mode "$mon" | sed 's/Hz$//')" "$(cur_pos "$mon")" "$choice"
}

# ── workspace menu ────────────────────────────────────────────────────────────

menu_workspaces() {
    local mon="$1"
    # Snapshot current assignments for this monitor from WS_ASSIGN
    local assigned=()
    for ws in $(seq 1 10); do
        [[ "${WS_ASSIGN[$ws]}" == "$mon" ]] && assigned+=("$ws")
    done

    while true; do
        local options=()
        for i in $(seq 1 10); do
            local cur_mon="${WS_ASSIGN[$i]}"
            if printf '%s\n' "${assigned[@]}" | grep -qx "$i"; then
                options+=("✓ Workspace $i")
            else
                # Show which monitor it's currently on
                options+=("  Workspace $i  (${cur_mon})")
            fi
        done
        options+=("─────" "Apply & Done")

        local choice
        choice=$(pick "Workspaces — $mon  (toggle to assign)" "${options[@]}") || break
        [[ -z "$choice" ]] && break

        case "$choice" in
            "Apply & Done"|"─────") break ;;
            *"Workspace "*)
                local num
                num=$(echo "$choice" | grep -oP 'Workspace \K[0-9]+')
                if printf '%s\n' "${assigned[@]}" | grep -qx "$num"; then
                    assigned=("${assigned[@]/$num}")
                    mapfile -t assigned < <(printf '%s\n' "${assigned[@]}" | grep .)
                else
                    assigned+=("$num")
                fi
                ;;
        esac
    done

    # Update WS_ASSIGN: assign selected workspaces to this monitor.
    # Workspaces removed from this monitor keep their previous assignment.
    for ws in "${assigned[@]}"; do
        WS_ASSIGN[$ws]="$mon"
    done

    # Move existing (visited) workspaces live
    move_workspaces "$mon" "${assigned[@]}"
}

# ── disable/enable ────────────────────────────────────────────────────────────

toggle_monitor() {
    local mon="$1"
    local disabled
    disabled=$(mon_field "$mon" '.disabled')
    if [[ "$disabled" == "true" ]]; then
        hyprctl keyword monitor "$mon,$(cur_mode "$mon" | sed 's/Hz$//'),$(cur_pos "$mon"),$(cur_scale "$mon")"
    else
        hyprctl keyword monitor "$mon,disabled"
    fi
}

# ── monitor submenu ───────────────────────────────────────────────────────────

menu_monitor() {
    local mon="$1"

    while true; do
        local mons mode pos scale ws_list model disabled_label
        mons=$(mons_json)
        mode=$(echo "$mons"  | jq -r --arg n "$mon" '.[] | select(.name==$n) | "\(.width)x\(.height)@\(.refreshRate | floor)Hz"')
        pos=$(echo "$mons"   | jq -r --arg n "$mon" '.[] | select(.name==$n) | "\(.x),\(.y)"')
        scale=$(echo "$mons" | jq -r --arg n "$mon" '.[] | select(.name==$n) | .scale')
        model=$(echo "$mons" | jq -r --arg n "$mon" '.[] | select(.name==$n) | .model')
        disabled=$(echo "$mons" | jq -r --arg n "$mon" '.[] | select(.name==$n) | .disabled')
        ws_list=$(mon_workspaces "$mon")
        [[ "$disabled" == "true" ]] && disabled_label="Enable monitor" || disabled_label="Disable monitor"

        local wp_file="${MON_WALLPAPER[$mon]##*/}"

        local choice
        choice=$(pick "$mon — $model" \
            "Resolution    $mode" \
            "Position      $pos" \
            "Scale         $scale" \
            "Workspaces    ${ws_list:-none}" \
            "Wallpaper     ${wp_file:-none}" \
            "──────────────────────────" \
            "$disabled_label" \
            "← Back") || return

        case "$choice" in
            Resolution*)   menu_resolution "$mon" ;;
            Position*)     menu_position   "$mon" ;;
            Scale*)        menu_scale      "$mon" ;;
            Workspaces*)   menu_workspaces "$mon" ;;
            Wallpaper*)    menu_wallpaper  "$mon" ;;
            "Disable"*|"Enable"*) toggle_monitor "$mon" ;;
            "← Back"|"")  return ;;
        esac
    done
}

# ── save hyprpaper.conf ───────────────────────────────────────────────────────

save_hyprpaper() {
    [[ -f "$HYPRPAPER_CONF" ]] || return

    mapfile -t mon_names < <(mons_json | jq -r '.[].name')

    # Collect unique paths for preload lines
    declare -A unique_paths
    for mon in "${mon_names[@]}"; do
        local p="${MON_WALLPAPER[$mon]}"
        [[ -n "$p" ]] && unique_paths[$p]=1
    done

    {
        # Preserve non-wallpaper lines (variables, splash, ipc); strip old wallpaper blocks
        local in_block=0
        while IFS= read -r line; do
            local s="${line//[[:space:]]}"
            if [[ "$s" == "wallpaper{"* || "$s" == "wallpaper{"  ]]; then
                in_block=1; continue
            fi
            [[ "$in_block" == 1 && "$s" == "}" ]] && { in_block=0; continue; }
            [[ "$in_block" == 1 ]] && continue
            # Also skip old preload lines; we'll rewrite them
            [[ "$s" == "preload="* ]] && continue
            echo "$line"
        done < "$HYPRPAPER_CONF"

        echo ""
        # Preload each unique wallpaper once
        for p in "${!unique_paths[@]}"; do
            echo "preload = $p"
        done

        echo ""
        # One wallpaper block per monitor
        for mon in "${mon_names[@]}"; do
            printf 'wallpaper {\n  monitor = %s\n  path = %s\n}\n\n' "$mon" "${MON_WALLPAPER[$mon]}"
        done
    } > "${HYPRPAPER_CONF}.tmp" && mv "${HYPRPAPER_CONF}.tmp" "$HYPRPAPER_CONF"
}

# ── save to monitors.conf ─────────────────────────────────────────────────────

save_config() {
    local mons
    mons=$(mons_json)

    {
        echo "# Generated by monitor-menu.sh on $(date)"
        echo ""
        # monitor lines
        while IFS= read -r name; do
            local w h hz x y scale disabled
            w=$(echo "$mons"        | jq -r --arg n "$name" '.[] | select(.name==$n) | .width')
            h=$(echo "$mons"        | jq -r --arg n "$name" '.[] | select(.name==$n) | .height')
            hz=$(echo "$mons"       | jq -r --arg n "$name" '.[] | select(.name==$n) | .refreshRate')
            x=$(echo "$mons"        | jq -r --arg n "$name" '.[] | select(.name==$n) | .x')
            y=$(echo "$mons"        | jq -r --arg n "$name" '.[] | select(.name==$n) | .y')
            scale=$(echo "$mons"    | jq -r --arg n "$name" '.[] | select(.name==$n) | .scale')
            disabled=$(echo "$mons" | jq -r --arg n "$name" '.[] | select(.name==$n) | .disabled')
            if [[ "$disabled" == "true" ]]; then
                echo "monitor=$name,disabled"
            else
                echo "monitor=$name,${w}x${h}@${hz},${x}x${y},${scale}"
            fi
        done < <(echo "$mons" | jq -r '.[].name')

        echo ""
        # workspace lines — all 10, from WS_ASSIGN
        for ws in $(seq 1 10); do
            local mon="${WS_ASSIGN[$ws]}"
            [[ -n "$mon" ]] && echo "workspace=$ws,monitor:$mon"
        done

    } > ~/.config/hypr/monitors.conf

    save_hyprpaper

    pick "Saved!" "✓ monitors.conf + hyprpaper.conf updated — OK" > /dev/null
}

# ── main menu ─────────────────────────────────────────────────────────────────

init_ws_assign
init_mon_wallpaper

while true; do
    mons=$(mons_json)

    mapfile -t entries < <(
        echo "$mons" | jq -r '.[] | "\(.name)   \(.model)   \(.width)x\(.height)@\(.refreshRate | floor)Hz   pos:\(.x),\(.y)"'
    )

    choice=$(pick "Monitor Configuration" \
        "${entries[@]}" \
        "──────────────────────────────────" \
        "Wallpaper (all monitors)" \
        "Save to monitors.conf" \
        "Exit") || break

    case "$choice" in
        "Wallpaper (all monitors)") menu_wallpaper_all ;;
        "Save to monitors.conf")    save_config ;;
        "Exit"|"") break ;;
        *)
            mon_name=$(echo "$choice" | awk '{print $1}')
            [[ -n "$mon_name" ]] && menu_monitor "$mon_name"
            ;;
    esac
done
