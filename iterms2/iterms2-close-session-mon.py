#!/usr/bin/env python3.7

import asyncio
import iterm2
import os

# if you want to reconnect the disconnected session, press the enter key in the disconnected tab

async def main(connection):
    app = await iterm2.async_get_app(connection)
    closedSess = list()

    async def ReConnectSession():
        app = await iterm2.async_get_app(connection)
        cwin = app.current_window
        if not cwin:
            return

        cur_tab = cwin.current_tab
        cur_sess = cur_tab.current_session
        sid = cur_sess.session_id

        idx = -1
        try:
            idx = closedSess.index(sid)
        except:
            return

        cur_profile = await cur_sess.async_get_profile()
        print("Reconnect: %s, %s" %(cur_profile.name, sid))

        try:
            await cur_sess.async_restart(True)
            closedSess.remove(sid)
        except:
            print("err")
            pass

    def SetKeyboardLanguage():
        # install: https://github.com/laishulu/macism
        #macism com.apple.inputmethod.Korean.2SetKorean
        #macism com.apple.keylayout.US
        #print("set input-source to US")
        os.system("macism com.apple.keylayout.US")

    async def keystroke_handler(keystroke):
        key = keystroke.keycode
        if key == iterm2.Keycode.ESCAPE:
            SetKeyboardLanguage()
            return
        elif key != iterm2.Keycode.RETURN:
            #print("press other key: %s" % key)
            return

        await ReConnectSession()

    async def runSessionTerminateMon():
        # Monitor termination of session
        async with iterm2.SessionTerminationMonitor(connection) as mon:
            while True:
                session_id = await mon.async_get()
                sid = session_id
                closedSess.append(sid)

    asyncio.create_task(runSessionTerminateMon())

    async def runNewSessionMon():
        # Monitor new session
        async with iterm2.NewSessionMonitor(connection) as mon:
            while True:
                session_id = await mon.async_get()
                SetKeyboardLanguage()

    #asyncio.create_task(runNewSessionMon())

    async def runFocusMon():
        async with iterm2.FocusMonitor(connection) as mon:
            while True:
                update = await mon.async_get_next_update()
                if update.selected_tab_changed:
                    SetKeyboardLanguage()

    asyncio.create_task(runFocusMon())

    # Monitor the keyboard
    async with iterm2.KeystrokeMonitor(connection) as mon:
        while True:
            keystroke = await mon.async_get()
            await keystroke_handler(keystroke)

iterm2.run_forever(main)

