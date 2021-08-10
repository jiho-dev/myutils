#!/usr/bin/env python3

# copy it to ~/Library/Application Support/iTerm2/Scripts
# to run automatically the script, place them in:
#   $HOME/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch
# map the hostkey with each function

import iterm2
import time

# it enables changing-woring-directory when the new connection opens
# you have install the user variables features

async def main(connection):

    async def isShellIntegrated(cur_sess):
        app = await iterm2.async_get_app(connection)
        remote_user_hostname = await cur_sess.async_get_variable(name="user.hostname")

        print("Current Session: user.hostname=%s" % (remote_user_hostname))

        if remote_user_hostname is None:
            return False

        return True

    async def isLocalHost(cur_sess):
        app = await iterm2.async_get_app(connection)
        local_hostname = await app.async_get_variable(name="localhostName")
        remote_user_hostname = await cur_sess.async_get_variable(name="user.hostname")

        print("HostName: localhostName=%s, user.hostname=%s" % (local_hostname, remote_user_hostname))

        if not local_hostname or not remote_user_hostname:
            return False
        elif local_hostname == remote_user_hostname:
            return True

        return False

    async def changeWorkingDirectory(profile_name, cur_sess, new_sess):
        enabled = await isShellIntegrated(cur_sess)
        isLocal = await isLocalHost(cur_sess)
        if isLocal:
            print("Skip changeWorkingDirectory because the localhost is Mac OS")
            return

        if enabled:
            cur_dir = await cur_sess.async_get_variable(name="user.path")
            print("user.path by integrated shell: %s" % cur_dir)
            time.sleep(0.2)

        else:
            ## if vim is running in the terminal, it won't work
            return

            #msg="stty -echo; printf \"\\e]1337;SetUserVar=%s=%s\\a\" path $(echo -n $(pwd) | base64); stty echo \n"

            await cur_sess.async_send_text("stty -echo \n" , True)
            time.sleep(0.2)
            msg="printf \"\\e]1337;SetUserVar=%s=%s\\a\" path $(echo -n $(pwd) | base64); stty echo \n"
            await cur_sess.async_send_text(msg , True)
            await cur_sess.async_send_text("\n" , True)
            time.sleep(0.5)

            cur_dir = await cur_sess.async_get_variable(name="user.path")
            print("user.path by dynamic command: %s" % cur_dir)

        if cur_dir:
            msg = "cd " + cur_dir + "\n"
            print("SendText: %s" % msg)
            await new_sess.async_send_text(msg, True)

    async def getCurrentTab():
        app = await iterm2.async_get_app(connection)
        cwin = app.current_window
        if not cwin:
            return None, None, None

        cur_tab = cwin.current_tab
        cur_sess = cur_tab.current_session
        await cur_sess.async_activate()

        try:
            cur_profile = await cur_sess.async_get_profile()

            return cur_tab, cur_sess, cur_profile.name
        except iterm2.RPCException as err:
            print("error: {0}".format(err))

        return None, None, None


    @iterm2.RPC
    async def duplicate_tab():

        cur_tab, cur_sess, cur_profile_name = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return

        print("Duplicate the Tab with Profile: %s" % cur_profile_name)
        app = await iterm2.async_get_app(connection)
        cwin = app.current_window
        tabs = list(cwin.tabs)
        cur_tab_idx = tabs.index(cur_tab)

        new_tab = await cwin.async_create_tab(profile=cur_profile_name, index=cur_tab_idx + 1)
        await new_tab.async_activate()
        new_sess = new_tab.current_session
        await new_sess.async_activate()
        await changeWorkingDirectory(cur_profile_name, cur_sess, new_sess)

    await duplicate_tab.async_register(connection)

    @iterm2.RPC
    async def duplicate_tab_in_window():

        cur_tab, cur_sess, cur_profile_name = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return

        print("Duplicate the Tab in the new window with Profile: %s" % cur_profile_name)
        new_win = await iterm2.Window.async_create(connection=connection, profile=cur_profile_name)
        new_tab = new_win.current_tab
        await new_tab.async_activate()
        new_sess = new_tab.current_session
        await new_sess.async_activate()
        await changeWorkingDirectory(cur_profile_name, cur_sess, new_sess)

    await duplicate_tab_in_window.async_register(connection)

    @iterm2.RPC
    async def vsplit_tab():

        cur_tab, cur_sess, cur_profile_name = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return

        print("VSplit the Tab with Profile: %s" % cur_profile_name)
        new_sess = await cur_sess.async_split_pane(vertical=True, profile=cur_profile_name)
        await new_sess.async_activate()

        await changeWorkingDirectory(cur_profile_name, cur_sess, new_sess)

    await vsplit_tab.async_register(connection)

    @iterm2.RPC
    async def hsplit_tab():
        cur_tab, cur_sess, cur_profile_name = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return

        print("HSplit th Tab with Profile: %s" % cur_profile_name)
        new_sess = await cur_sess.async_split_pane(vertical=False, profile=cur_profile_name)
        await new_sess.async_activate()

        await changeWorkingDirectory(cur_profile_name, cur_sess, new_sess)

    await hsplit_tab.async_register(connection)


    '''
    @iterm2.RPC
    async def duplicate_tab1():
        cwin = app.current_window
        if cwin is None:
            return

        modes = [iterm2.PromptMonitor.Mode.PROMPT,
                 iterm2.PromptMonitor.Mode.COMMAND_START,
                 iterm2.PromptMonitor.Mode.COMMAND_END]

        ctab = cwin.current_tab
        cur_sess = ctab.current_session
        cur_profile = await cur_sess.async_get_profile()
        profile_name = cur_profile.name

        # printf "\033]1337;SetUserVar=%s=%s\007" foo `echo -n bar | base64`
        msg="printf \"\\033]1337;SetUserVar=%s=%s\\007\" path $(echo -n $(pwd) | base64) \n"
        await cur_sess.async_send_text(msg , True)

        #async with cur_sess.get_screen_streamer() as streamer:
        #    await streamer.async_get()

        time.sleep(0.5)
        foo = await cur_sess.async_get_variable(name="user.path")
        print("@@@path:" + foo)

        #\(matches[0])
        #pt = await iterm2.async_get_last_prompt(connection, cur_sess.session_id)
        #if pt is None:
        #    print("pt is none")
        #else:
        #    print("workingdir: " + pt.working_directory + "," + pt.command)

        #cur_dir = await cur_sess.async_get_variable(name="path")
        #print("@@@dir:" + cur_dir)

    await duplicate_tab1.async_register(connection)


        modes = [iterm2.PromptMonitor.Mode.PROMPT,
                 iterm2.PromptMonitor.Mode.COMMAND_START,
                 iterm2.PromptMonitor.Mode.COMMAND_END]

        enable = await isShellIntegration(cur_sess)
        enable = False

        if enable:
            cur_dir = await cur_sess.async_get_variable(name="user.path")
            print("### user.path from prompt:" + cur_dir)

            async with iterm2.PromptMonitor(connection, new_sess.session_id, modes=modes) as mon:
                await mon.async_get()
                cur_dir = await cur_sess.async_get_variable(name="path")
                print("### dir from prompt:" + cur_dir)


            pt = await iterm2.async_get_last_prompt(connection, cur_sess.session_id)
            if pt is None:
                print("pt is none")
            else:
                print("workingdir: " + pt.working_directory + "," + pt.command)

        else:
            msg="printf \"\\033]1337;SetUserVar=%s=%s\\007\" path $(echo -n $(pwd) | base64) \n"
            await cur_sess.async_send_text(msg , True)
            time.sleep(0.5)
            cur_dir = await cur_sess.async_get_variable(name="user.path")
            print("### dir from user variable:" + cur_dir)
    '''
    '''
    print("profile_name: " + cur_profile.name, cur_profile.command, cur_profile.use_custom_command)
    if cur_profile.use_custom_command:
        cmd = cur_profile.command + " -t \'bash -ic \"cd ~/src; exec bash\"\'"
        await cur_profile.async_set_command(cmd)
        #ssh -i /Users/jiho.jung/Documents/ssh-keys/joyent-github-id_rsa.priv jiho.jung@172.30.1.72 -t 'bash -ic "cd ~/src; exec bash"'
        print("after profile_name: " + cur_profile.name, cur_profile.command, cur_profile.use_custom_command)
    '''


iterm2.run_forever(main)


