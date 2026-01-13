#!/bin/bash

# Fix glitchart - Remove complex animations
cat > style-glitchart.css << 'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font";
    font-weight: 600;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: transparent;
}

/* Glitch Art - RGB Color Split Theme */

#workspaces,
#window,
#mode,
#submap {
    background: rgba(10, 10, 15, 0.95);
    margin: 4px 0px 4px 8px;
    padding: 4px 14px;
    border-radius: 8px;
    color: #00ff00;
    text-shadow: 2px 0 #ff00ff, -2px 0 #00ffff;
    border: 2px solid #00ff00;
    box-shadow: 2px 2px 0 #ff00ff, -2px -2px 0 #00ffff;
}

#custom-disk,
#temperature,
#cpu,
#memory,
#custom-gpu {
    background: rgba(10, 10, 15, 0.95);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #ff00ff;
    text-shadow: 2px 0 #00ffff, -2px 0 #ffff00;
    border-top: 2px solid #ff00ff;
    border-bottom: 2px solid #ff00ff;
    border-left: none;
    border-right: none;
}

#custom-disk {
    margin-left: 8px;
    border-left: 2px solid #ff00ff;
    border-top-left-radius: 8px;
    border-bottom-left-radius: 8px;
}

#custom-gpu {
    margin-right: 0px;
    border-right: 2px solid #ff00ff;
    border-top-right-radius: 8px;
    border-bottom-right-radius: 8px;
}

#backlight,
#battery {
    background: rgba(10, 10, 15, 0.95);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #00ffff;
    text-shadow: 2px 0 #ff00ff, -2px 0 #ffff00;
    border-top: 2px solid #00ffff;
    border-bottom: 2px solid #00ffff;
    border-left: none;
    border-right: none;
}

#backlight {
    margin-left: 8px;
    min-width: 60px;
    border-left: 2px solid #00ffff;
    border-top-left-radius: 8px;
    border-bottom-left-radius: 8px;
}

#battery {
    margin-right: 0px;
    min-width: 70px;
    border-right: 2px solid #00ffff;
    border-top-right-radius: 8px;
    border-bottom-right-radius: 8px;
}

#pulseaudio {
    background: rgba(10, 10, 15, 0.95);
    margin: 4px 8px;
    padding: 4px 12px;
    min-width: 80px;
    color: #ffff00;
    text-shadow: 2px 0 #ff00ff, -2px 0 #00ffff;
    border: 2px solid #ffff00;
    border-radius: 8px;
    box-shadow: 2px 2px 0 #ff00ff, -2px -2px 0 #00ffff;
}

#network,
#tray {
    background: rgba(10, 10, 15, 0.95);
    margin: 4px 2px;
    padding: 4px 12px;
    color: #ff0080;
    text-shadow: 2px 0 #00ff80, -2px 0 #0080ff;
    border: 2px solid #ff0080;
    box-shadow: 2px 2px 0 #00ff80, -2px -2px 0 #0080ff;
    border-radius: 8px;
}

#network {
    margin-left: 8px;
    min-width: 330px;
}

#tray {
    margin-right: 8px;
}

#clock {
    background: rgba(10, 10, 15, 0.95);
    margin: 4px 0px;
    padding: 4px 16px;
    border-radius: 8px;
    color: #ffffff;
    font-weight: 700;
    text-shadow: 2px 0 #ff0000, -2px 0 #0000ff;
    border: 2px solid #ffffff;
    box-shadow: 2px 2px 0 #ff0000, -2px -2px 0 #0000ff;
}

#workspaces {
    padding: 2px 6px;
}

#workspaces button {
    color: rgba(0, 255, 0, 0.4);
    padding: 2px 10px;
    margin: 0px 3px;
    border-radius: 6px;
    background: transparent;
}

#workspaces button.active {
    color: #00ff00;
    text-shadow: 1px 0 #ff00ff, -1px 0 #00ffff;
    background: rgba(0, 255, 0, 0.15);
}

#workspaces button:hover {
    background: rgba(0, 255, 0, 0.1);
    color: #00ff00;
}

#workspaces button.urgent {
    color: #ff0000;
    text-shadow: 2px 0 #00ff00, -2px 0 #0000ff;
    background: rgba(255, 0, 0, 0.2);
}

#window,
#mode,
#submap {
    font-style: italic;
    color: #00ff00;
}

#temperature.critical {
    color: #ff0000;
    text-shadow: 2px 0 #00ff00, -2px 0 #0000ff;
}

#battery.charging {
    color: #00ff80;
    text-shadow: 2px 0 #ff0080, -2px 0 #0080ff;
}

#battery.warning:not(.charging) {
    color: #ffff00;
    text-shadow: 2px 0 #ff00ff, -2px 0 #00ffff;
}

#battery.critical:not(.charging) {
    color: #ff0000;
    text-shadow: 2px 0 #00ff00, -2px 0 #0000ff;
}

#network.disconnected {
    color: #ff0000;
    text-shadow: 2px 0 #00ff00, -2px 0 #0000ff;
}

#pulseaudio.muted {
    color: rgba(255, 255, 0, 0.3);
    text-shadow: 1px 0 rgba(255, 0, 255, 0.3), -1px 0 rgba(0, 255, 255, 0.3);
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
}
EOF

# Fix LCD
cat > style-lcd.css << 'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font";
    font-weight: 700;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: transparent;
}

/* LCD Display - Digital Calculator/Watch Style */

#workspaces,
#window,
#mode,
#submap {
    background: linear-gradient(180deg, #8ba88b 0%, #a3c6a3 50%, #8ba88b 100%);
    margin: 4px 0px 4px 8px;
    padding: 4px 14px;
    border-radius: 6px;
    color: #1a341a;
    font-family: "Courier New", monospace;
    font-weight: 900;
    border: 3px solid #4d6b4d;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
}

#custom-disk,
#temperature,
#cpu,
#memory,
#custom-gpu {
    background: linear-gradient(180deg, #8ba88b 0%, #a3c6a3 50%, #8ba88b 100%);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #1a341a;
    font-family: "Courier New", monospace;
    font-weight: 900;
    border-top: 3px solid #4d6b4d;
    border-bottom: 3px solid #4d6b4d;
    border-left: none;
    border-right: none;
}

#custom-disk {
    margin-left: 8px;
    border-left: 3px solid #4d6b4d;
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
}

#custom-gpu {
    margin-right: 0px;
    border-right: 3px solid #4d6b4d;
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
}

#backlight,
#battery {
    background: linear-gradient(180deg, #8ba88b 0%, #a3c6a3 50%, #8ba88b 100%);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #1a341a;
    font-family: "Courier New", monospace;
    font-weight: 900;
    border-top: 3px solid #4d6b4d;
    border-bottom: 3px solid #4d6b4d;
    border-left: none;
    border-right: none;
}

#backlight {
    margin-left: 8px;
    min-width: 60px;
    border-left: 3px solid #4d6b4d;
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
}

#battery {
    margin-right: 0px;
    min-width: 70px;
    border-right: 3px solid #4d6b4d;
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
}

#pulseaudio {
    background: linear-gradient(180deg, #8ba88b 0%, #a3c6a3 50%, #8ba88b 100%);
    margin: 4px 8px;
    padding: 4px 12px;
    min-width: 80px;
    color: #1a341a;
    font-family: "Courier New", monospace;
    font-weight: 900;
    border: 3px solid #4d6b4d;
    border-radius: 6px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
}

#network,
#tray {
    background: linear-gradient(180deg, #8ba88b 0%, #a3c6a3 50%, #8ba88b 100%);
    margin: 4px 2px;
    padding: 4px 12px;
    color: #1a341a;
    font-family: "Courier New", monospace;
    font-weight: 900;
    border: 3px solid #4d6b4d;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
    border-radius: 6px;
}

#network {
    margin-left: 8px;
    min-width: 330px;
}

#tray {
    margin-right: 8px;
}

#clock {
    background: linear-gradient(180deg, #8ba88b 0%, #a3c6a3 50%, #8ba88b 100%);
    margin: 4px 0px;
    padding: 4px 16px;
    border-radius: 6px;
    color: #1a341a;
    font-family: "Courier New", monospace;
    font-weight: 900;
    font-size: 14px;
    border: 3px solid #4d6b4d;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
}

#workspaces {
    padding: 2px 6px;
}

#workspaces button {
    color: rgba(26, 52, 26, 0.5);
    padding: 2px 10px;
    margin: 0px 3px;
    border-radius: 4px;
    background: rgba(0, 0, 0, 0.1);
}

#workspaces button.active {
    color: #1a341a;
    background: rgba(0, 0, 0, 0.2);
}

#workspaces button:hover {
    background: rgba(0, 0, 0, 0.15);
    color: #1a341a;
}

#workspaces button.urgent {
    color: #1a341a;
    background: rgba(0, 0, 0, 0.3);
}

#window,
#mode,
#submap {
    font-style: normal;
    color: #1a341a;
}

#temperature.critical {
    background: rgba(0, 0, 0, 0.1);
}

#battery.charging {
    color: #1a341a;
}

#battery.warning:not(.charging) {
    color: #1a341a;
}

#battery.critical:not(.charging) {
    background: rgba(0, 0, 0, 0.1);
}

#network.disconnected {
    color: rgba(26, 52, 26, 0.5);
}

#pulseaudio.muted {
    color: rgba(26, 52, 26, 0.4);
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
}
EOF

# Fix gradient
cat > style-gradient.css << 'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font";
    font-weight: 600;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: transparent;
}

/* Gradient - Flowing Colors */

#workspaces,
#window,
#mode,
#submap {
    background: linear-gradient(90deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
    margin: 4px 0px 4px 8px;
    padding: 4px 14px;
    border-radius: 14px;
    color: #ffffff;
    font-weight: 700;
    border: 2px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
}

#custom-disk,
#temperature,
#cpu,
#memory,
#custom-gpu {
    background: linear-gradient(90deg, #fa709a 0%, #fee140 50%, #30cfd0 100%);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #ffffff;
    font-weight: 700;
    border-top: 2px solid rgba(255, 255, 255, 0.3);
    border-bottom: 2px solid rgba(255, 255, 255, 0.3);
    border-left: none;
    border-right: none;
}

#custom-disk {
    margin-left: 8px;
    border-left: 2px solid rgba(255, 255, 255, 0.3);
    border-top-left-radius: 14px;
    border-bottom-left-radius: 14px;
}

#custom-gpu {
    margin-right: 0px;
    border-right: 2px solid rgba(255, 255, 255, 0.3);
    border-top-right-radius: 14px;
    border-bottom-right-radius: 14px;
}

#backlight,
#battery {
    background: linear-gradient(90deg, #f093fb 0%, #f5576c 50%, #4facfe 100%);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #ffffff;
    font-weight: 700;
    border-top: 2px solid rgba(255, 255, 255, 0.3);
    border-bottom: 2px solid rgba(255, 255, 255, 0.3);
    border-left: none;
    border-right: none;
}

#backlight {
    margin-left: 8px;
    min-width: 60px;
    border-left: 2px solid rgba(255, 255, 255, 0.3);
    border-top-left-radius: 14px;
    border-bottom-left-radius: 14px;
}

#battery {
    margin-right: 0px;
    min-width: 70px;
    border-right: 2px solid rgba(255, 255, 255, 0.3);
    border-top-right-radius: 14px;
    border-bottom-right-radius: 14px;
}

#pulseaudio {
    background: linear-gradient(90deg, #4facfe 0%, #00f2fe 50%, #43e97b 100%);
    margin: 4px 8px;
    padding: 4px 12px;
    min-width: 80px;
    color: #ffffff;
    font-weight: 700;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 14px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
}

#network,
#tray {
    background: linear-gradient(90deg, #a8edea 0%, #fed6e3 50%, #ace0f9 100%);
    margin: 4px 2px;
    padding: 4px 12px;
    color: #2d3748;
    font-weight: 700;
    border: 2px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
    border-radius: 14px;
}

#network {
    margin-left: 8px;
    min-width: 330px;
}

#tray {
    margin-right: 8px;
}

#clock {
    background: linear-gradient(90deg, #ff0844 0%, #ffb199 50%, #ff0844 100%);
    margin: 4px 0px;
    padding: 4px 16px;
    border-radius: 14px;
    color: #ffffff;
    font-weight: 900;
    border: 2px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
}

#workspaces {
    padding: 2px 6px;
}

#workspaces button {
    color: rgba(255, 255, 255, 0.6);
    padding: 2px 10px;
    margin: 0px 3px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.1);
}

#workspaces button.active {
    color: #ffffff;
    background: rgba(255, 255, 255, 0.25);
}

#workspaces button:hover {
    background: rgba(255, 255, 255, 0.18);
    color: #ffffff;
}

#workspaces button.urgent {
    color: #ffffff;
    background: rgba(255, 255, 255, 0.35);
}

#window,
#mode,
#submap {
    font-style: italic;
    color: rgba(255, 255, 255, 0.95);
}

#temperature.critical {
    background: linear-gradient(90deg, #ff0844 0%, #ff5555 100%);
}

#battery.charging {
    background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
}

#battery.warning:not(.charging) {
    background: linear-gradient(90deg, #fa709a 0%, #fee140 100%);
}

#battery.critical:not(.charging) {
    background: linear-gradient(90deg, #ff0844 0%, #ff5555 100%);
}

#network.disconnected {
    background: linear-gradient(90deg, #868f96 0%, #596164 100%);
}

#pulseaudio.muted {
    background: linear-gradient(90deg, #868f96 0%, #596164 100%);
    color: rgba(255, 255, 255, 0.6);
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
}
EOF

# Fix depth
cat > style-depth.css << 'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font";
    font-weight: 600;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: transparent;
}

/* Layered Depth - Multiple Shadow Layers */

#workspaces,
#window,
#mode,
#submap {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    margin: 4px 0px 4px 8px;
    padding: 4px 14px;
    border-radius: 12px;
    color: #ffffff;
    border: none;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
}

#custom-disk,
#temperature,
#cpu,
#memory,
#custom-gpu {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #ffffff;
    border: none;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14);
}

#custom-disk {
    margin-left: 8px;
    border-top-left-radius: 12px;
    border-bottom-left-radius: 12px;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
}

#custom-gpu {
    margin-right: 0px;
    border-top-right-radius: 12px;
    border-bottom-right-radius: 12px;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
}

#backlight,
#battery {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    margin: 4px 0px;
    padding: 4px 12px;
    color: #ffffff;
    border: none;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14);
}

#backlight {
    margin-left: 8px;
    min-width: 60px;
    border-top-left-radius: 12px;
    border-bottom-left-radius: 12px;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
}

#battery {
    margin-right: 0px;
    min-width: 70px;
    border-top-right-radius: 12px;
    border-bottom-right-radius: 12px;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
}

#pulseaudio {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    margin: 4px 8px;
    padding: 4px 12px;
    min-width: 80px;
    color: #ffffff;
    border: none;
    border-radius: 12px;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
}

#network,
#tray {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
    margin: 4px 2px;
    padding: 4px 12px;
    color: #2d3748;
    border: none;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16);
    border-radius: 12px;
}

#network {
    margin-left: 8px;
    min-width: 330px;
}

#tray {
    margin-right: 8px;
}

#clock {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
    margin: 4px 0px;
    padding: 4px 16px;
    border-radius: 12px;
    color: #ffffff;
    font-weight: 700;
    border: none;
    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.1),
                0 4px 4px rgba(0, 0, 0, 0.12),
                0 8px 8px rgba(0, 0, 0, 0.14),
                0 16px 16px rgba(0, 0, 0, 0.16),
                0 32px 32px rgba(0, 0, 0, 0.18);
}

#workspaces {
    padding: 2px 6px;
}

#workspaces button {
    color: rgba(255, 255, 255, 0.6);
    padding: 2px 10px;
    margin: 0px 3px;
    border-radius: 8px;
    background: rgba(0, 0, 0, 0.1);
}

#workspaces button.active {
    color: #ffffff;
    background: rgba(255, 255, 255, 0.15);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

#workspaces button:hover {
    background: rgba(255, 255, 255, 0.12);
    color: #ffffff;
}

#workspaces button.urgent {
    color: #ffffff;
    background: rgba(255, 0, 0, 0.3);
    box-shadow: 0 2px 8px rgba(255, 0, 0, 0.4);
}

#window,
#mode,
#submap {
    font-style: italic;
    color: rgba(255, 255, 255, 0.95);
}

#temperature.critical {
    background: linear-gradient(135deg, #ff0844 0%, #ffb199 100%);
}

#battery.charging {
    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

#battery.warning:not(.charging) {
    background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

#battery.critical:not(.charging) {
    background: linear-gradient(135deg, #ff0844 0%, #ffb199 100%);
}

#network.disconnected {
    background: linear-gradient(135deg, #868f96 0%, #596164 100%);
}

#pulseaudio.muted {
    background: linear-gradient(135deg, #868f96 0%, #596164 100%);
    color: rgba(255, 255, 255, 0.6);
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
}
EOF

echo "All themes have been fixed for Waybar compatibility!"
