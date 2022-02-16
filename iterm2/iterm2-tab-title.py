#!/usr/bin/env python3

import asyncio
import iterm2
import os
import subprocess
import sys

def hostname_dash_f():
    process = subprocess.Popen(["hostname", "-f"], stdout=subprocess.PIPE)
    (output, err) = process.communicate()
    exit_code = process.wait()
    return output.decode('utf-8').rstrip()

def shortened_hostname(h):
    i = h.find(".")
    if i < 0:
        return h
    else:
        return h[:i]

def make_title(auto_name, profile_name):
    if auto_name != profile_name:
        return auto_name
    else:
        return ""

def make_hostname(hostname, localhost):
    if not hostname:
        return ""
    short_hostname = shortened_hostname(hostname)
    if short_hostname and short_hostname != localhost:
        return short_hostname
        #return "➥ " + short_hostname

    return ""

def make_pwd(user_home, localhome, pwd):
    if pwd:
        if user_home:
            home = user_home
        else:
            home = localhome
        home_prefix = "📂 "
        if pwd == home:
            home_prefix = ""
            pwd = "🏡"
        elif pwd.startswith(home):
            pwd = "~" + pwd[len(home):]
        if pwd:
            return home_prefix + pwd
    return ""

def make_branch(branch):
    if branch:
        return " ⎇ " + branch.rstrip()
    return ""

# https://iterm2.com/python-api/examples/georges_title.html#georges-title-example

async def main(connection):
    localhome = os.environ.get("HOME")
    localhost = hostname_dash_f()

    @iterm2.TitleProviderRPC
    async def tab_title_fixed_hostname(
        hostname=iterm2.Reference("hostname?"),
        user_hostname=iterm2.Reference("user.hostname?"),
        user_remote_hostname=iterm2.Reference("user.remote_hostname?"),

        auto_name=iterm2.Reference("autoName?"),
        profile_name=iterm2.Reference("profileName?")):

        if user_remote_hostname:
            return user_remote_hostname

        if user_hostname:
            return user_hostname

        return make_hostname(hostname, localhost)

    await tab_title_fixed_hostname.async_register(
            connection,
            display_name="FixedHostName",
            unique_identifier="com.iterm2.example.tab-title-fixed-hostname")

iterm2.run_forever(main)
