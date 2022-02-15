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

    async def isLocalHost(cur_sess):
        app = await iterm2.async_get_app(connection)
        local_hostname = await app.async_get_variable(name="localhostName")
        user_hostname = await cur_sess.async_get_variable(name="user.hostname")

        print("HostName: localhostName=%s, user.hostname=%s" % (local_hostname, user_hostname))

        if not local_hostname or not user_hostname:
            return False
        elif local_hostname == user_hostname:
            return True

        return False

    async def sendText(msg, new_sess):
        if not msg:
            return

        time.sleep(0.2)
        print("SendText: %s" % msg)
        msg += "\n"

        await new_sess.async_send_text(msg, True)

    async def changeDir(cur_sess, new_sess):
        # change dir
        cur_dir = await cur_sess.async_get_variable(name="user.path")
        if not cur_dir:
            return

        msg = "cd " + cur_dir
        print("user.path by integrated shell: [%s]" % cur_dir)
        await sendText(msg, new_sess)
    
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
            
            return cur_tab, cur_sess, cur_profile

        except iterm2.RPCException as err:
            print("error: {0}".format(err))

        return None, None, None

    async def getCommand(tab, profile):
        sess = tab.current_session        
        user_remote_hostname = await sess.async_get_variable(name="user.remote_hostname")
        
        cmd = None
        msg = None
        if not user_remote_hostname:
            return None, None

        if "sss" in profile.command:
            cmd = profile.command + " " +user_remote_hostname
        else:
            # XXX: resolve path for sss
            msg = "sss " + user_remote_hostname

        return cmd, msg

    @iterm2.RPC
    async def duplicate_tab():
        print("\nDuplicate the Tab")

        cur_tab, cur_sess, cur_profile = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return

        isLocal = await isLocalHost(cur_sess)
        cmd, msg = await getCommand(cur_tab, cur_profile)
        cur_profile_name = cur_profile.name

        print("Duplicate the Tab with Profile: name:%s, cmd:%s, new_cmd:%s, msg:%s" % 
            (cur_profile_name, cur_profile.command, cmd, msg))

        app = await iterm2.async_get_app(connection)
        cwin = app.current_window
        tabs = list(cwin.tabs)
        cur_tab_idx = tabs.index(cur_tab)

        new_tab = await cwin.async_create_tab(profile=cur_profile_name, command=cmd, index=cur_tab_idx + 1)
        #new_tab = await cwin.async_create_tab(profile=cur_profile_name, index=cur_tab_idx + 1)
        new_sess = new_tab.current_session

        await new_tab.async_activate()
        await new_sess.async_activate()

        if msg:
            # send msg
            await sendText(msg, new_sess)
        elif not isLocal:
            # change dir
            await changeDir(cur_sess, new_sess)

    await duplicate_tab.async_register(connection)

    @iterm2.RPC
    async def duplicate_tab_in_window():
        print("\nDuplicate the Tab in Window")

        cur_tab, cur_sess, cur_profile = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return
        
        isLocal = await isLocalHost(cur_sess)
        cmd, msg = await getCommand(cur_tab, cur_profile)
        cur_profile_name = cur_profile.name

        print("Duplicate the Tab with Profile: name:%s, cmd:%s, new_cmd:%s, msg:%s" % 
            (cur_profile_name, cur_profile.command, cmd, msg))

        app = await iterm2.async_get_app(connection)
        cwin = app.current_window
        tabs = list(cwin.tabs)
        cur_tab_idx = tabs.index(cur_tab)

        new_win = await iterm2.Window.async_create(connection=connection, command=cmd, profile=cur_profile_name)
        #new_win = await iterm2.Window.async_create(connection=connection, profile=cur_profile_name)
        new_tab = new_win.current_tab
        await new_tab.async_activate()
        new_sess = new_tab.current_session

        await new_tab.async_activate()
        await new_sess.async_activate()

        if msg:
            # send msg
            await sendText(msg, new_sess)
        elif not isLocal:
            # change dir
            await changeDir(cur_sess, new_sess)


    await duplicate_tab_in_window.async_register(connection)

    @iterm2.RPC
    async def vsplit_tab():
        print("\nVSplit the Tab in Window")

        cur_tab, cur_sess, cur_profile = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return
        
        isLocal = await isLocalHost(cur_sess)
        cmd, msg = await getCommand(cur_tab, cur_profile)
        cur_profile_name = cur_profile.name

        print("Duplicate the Tab with Profile: name:%s, cmd:%s, new_cmd:%s, msg:%s" % 
            (cur_profile_name, cur_profile.command, cmd, msg))

        change = None
        if cmd:
            change = iterm2.LocalWriteOnlyProfile()
            change.set_command(cmd)
            change.set_use_custom_command("Yes")

        new_sess = await cur_sess.async_split_pane(vertical=True, profile=cur_profile_name, profile_customizations=change)
        #new_sess = await cur_sess.async_split_pane(vertical=True, profile=cur_profile_name)
        await new_sess.async_activate()

        if msg:
            # send msg
            await sendText(msg, new_sess)
        elif not isLocal:
            # change dir
            await changeDir(cur_sess, new_sess)

    await vsplit_tab.async_register(connection)

    @iterm2.RPC
    async def hsplit_tab():
        print("\nVSplit the Tab in Window")

        cur_tab, cur_sess, cur_profile = await getCurrentTab()
        if not cur_tab:
            print("Cannot find the currnet Tab")
            return
        
        isLocal = await isLocalHost(cur_sess)
        cmd, msg = await getCommand(cur_tab, cur_profile)
        cur_profile_name = cur_profile.name

        print("Duplicate the Tab with Profile: name:%s, cmd:%s, new_cmd:%s, msg:%s" % 
            (cur_profile_name, cur_profile.command, cmd, msg))

        change = None
        if cmd:
            change = iterm2.LocalWriteOnlyProfile()
            change.set_command(cmd)
            change.set_use_custom_command("Yes")

        new_sess = await cur_sess.async_split_pane(vertical=False, profile=cur_profile_name, profile_customizations=change)
        #new_sess = await cur_sess.async_split_pane(vertical=False, profile=cur_profile_name)
        await new_sess.async_activate()

        if msg:
            # send msg
            await sendText(msg, new_sess)
        elif not isLocal:
            # change dir
            await changeDir(cur_sess, new_sess)

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


