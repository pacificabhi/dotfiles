#!/usr/bin/env python3
import gi
import json
import sys

gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

def on_metadata(player, metadata):
    track_info = {
        'text': '',
        'tooltip': '',
        'class': '',
        'alt': ''
    }

    try:
        if player.props.status == 'Playing':
            artist = player.get_artist()
            title = player.get_title()

            if artist and title:
                track_info['text'] = f"{artist} - {title}"
                track_info['tooltip'] = f"{artist}\n{title}\n\nStatus: Playing"
                track_info['class'] = 'playing'
                track_info['alt'] = 'playing'
            elif title:
                track_info['text'] = title
                track_info['tooltip'] = f"{title}\n\nStatus: Playing"
                track_info['class'] = 'playing'
                track_info['alt'] = 'playing'
            else:
                track_info['text'] = "Playing"
                track_info['tooltip'] = "Media playing"
                track_info['class'] = 'playing'
                track_info['alt'] = 'playing'
        elif player.props.status == 'Paused':
            artist = player.get_artist()
            title = player.get_title()

            if artist and title:
                track_info['text'] = f"{artist} - {title}"
                track_info['tooltip'] = f"{artist}\n{title}\n\nStatus: Paused"
                track_info['class'] = 'paused'
                track_info['alt'] = 'paused'
            elif title:
                track_info['text'] = title
                track_info['tooltip'] = f"{title}\n\nStatus: Paused"
                track_info['class'] = 'paused'
                track_info['alt'] = 'paused'
            else:
                track_info['text'] = "Paused"
                track_info['tooltip'] = "Media paused"
                track_info['class'] = 'paused'
                track_info['alt'] = 'paused'
    except:
        pass

    print(json.dumps(track_info), flush=True)

def on_play(player, status):
    on_metadata(player, player.props.metadata)

def on_pause(player, status):
    on_metadata(player, player.props.metadata)

def init_player(name):
    try:
        player = Playerctl.Player.new_from_name(name)
        player.connect('playback-status::playing', on_play)
        player.connect('playback-status::paused', on_pause)
        player.connect('metadata', on_metadata)

        on_metadata(player, player.props.metadata)
        return player
    except:
        return None

def main():
    manager = Playerctl.PlayerManager()

    def on_name_appeared(manager, name):
        init_player(name)

    manager.connect('name-appeared', on_name_appeared)

    for name in manager.props.player_names:
        player = init_player(name)
        if player:
            break

    GLib.MainLoop().run()

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(json.dumps({'text': '', 'tooltip': '', 'class': '', 'alt': ''}))
        sys.exit(0)
