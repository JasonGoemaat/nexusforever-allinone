# NexusForever AllInOne

[NexusForever](https://www.emulator.ws/) is an open source server emulator
for the game [Wildstar](https://en.wikipedia.org/wiki/WildStar).

I created this repository to put together all the things needed for
someone to get a server up and running as easily as possible.  It took me a
night to get everything setup and some things weren't clear from the
[install guide](https://www.emulator.ws/installation/server-install-guide-windows),
but this is how I did it and everything I link to should be good enough
to get you started with your own server and able to login to it with
your client and start questing.  Many things are still a work in progress however,
expect many bugs with quests.

None of the main coding for the server was done by me, all credit goes to
the people that have worked for years to create [these projects](https://github.com/NexusForever)
and the helpful [Discord](https://discord.gg/nexusforever) community.

## Structure of this repository:

The `NexusForever`, `WorldData`, and `AdminUi` directories are submodules
linking to other repositories.

* `/NexusForever`
    * (git submodule) main source code for the game, three projects need to run
* `/WorldData`
    * (git submodule) repository with data, used to populate the mysql databases so there are things in the world
* `docker-compose.yml`
    * if you have docker installed, this will start a mysql container for the databases
* `/scripts`
    * scripts for helping to install the game
* `/AdminUI`
    * (git submodule)

The NexusForever and WorldData repositories are forks of the public repositories pinned
to commits I know work, if you want to check out changes and branches made by others these
are the original repositories:

* [NexusForever](https://github.com/NexusForever/NexusForever)
* [WorldDatabase](https://github.com/NexusForever/NexusForever.WorldDatabase)


## Prerequisites

1. [Docker](https://www.docker.com/)
2. [Visual Studio 2022](https://visualstudio.microsoft.com/vs/community/)
3. [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) or other tool like [HeidiSQL](https://www.heidisql.com/) for connecting to MySQL
4. WildStar 16042 client (see below)

## Getting Started

Generating the map and table files requires the client be installed which can take some
time, so skip down to that section and start the install before continuing if you
haven't installed it already.

> If you want to use different passwords, change the root password in
`docker-compose.yml` and change the `nexusforever` user's password
in `init.sql`, and change the `nexusforever` user's password in the
connection strings when you rename the three config files after building
the three servers using Visual Studio in step 5 below.  The docker file
should only allow connections from localhost so I don't think it's a
huge issue, but better safe than sorry.

1. Clone this repository with submodules
    * If not cloned with `--recurse-submodules`, run these commands:
        ```
        git submodule init 
        git submodule update
        ```
2. Run this command to start the MySQL docker container (add `-d` to start detached)
    ```
    docker-compose up
    ```
3. Using your query tool (MySQL Workbench or HeidiSQL):
    1. Connect to `127.0.0.1` as the user `root` with the password `DisIssssR00t` (or whatever you set in the `docker-compose.yml` file)
    2. Run the commands in [init.sql](init.sql) to setup the three databases and the `nexusforever` user
4. Open Visual Studio 2022 and open the solution `NexusForever/Source/NexusForever.sln`
    * Use CTRL+SHIFT+B to build all the projects
    * You should see they were all successfully built
5. Rename these files to remove the '.example' from them (and change nexusforever password in connection strings if you used something different):
    * `NexusForever/Source/NexusForever.AuthServer/bin/Debug/net6.0/AuthServer.example.json`
    * `NexusForever/Source/NexusForever.StsServer/bin/Debug/net6.0/StsServer.example.json`
    * `NexusForever/Source/NexusForever.WorldServer/bin/Debug/net6.0/WorldServer.example.json`
6. The first time WorldServer is run it will do database migrations, so you may want to run it first by itself to create the tables accessed in the other two:
    * Right-click on the NexusForever.WorldServer project and go to Debug (a little more than 1/2 way down) and select 'Start new instance'
    * Wait for migrations to happen (The game will be completely started when you see '`[DEBUG][Host] Hosting started`' in the log)
    * Use CTRL+C in the console window or hit the stop button in visual studio to stop the server
7. Go back to MySQL Workbench (Or HeidiSQL) 
    1. Change to the world database with the command:
        ```
        use nexus_forever_world;
        ```
    2. Run the script in `WorldDatabase/All in one/All in one.sql` to populate the database
8. Make sure you have the client installed with data downloaded and know the path to it (see below)
    * My path is `D:\Games\Wildstar`, which has 'Wildstart.exe' and the folders 'bootstrap', 'Client64', 'Errors', 'Launcher', and 'Patch' in it
9. Copy all the files in `NexusForever/Source/NexusForever.ClientConnector/bin/Debug/net6.0` to the 'Client64' directory where you installed Wildstar
    * You will start the game using `Client64/NexusForever.ClientConnector.exe` instead of Wildstar.exe
10. Open a terminal and go to `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0` and run these commands:
    * Generates a 'tbl' directory in `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0`, takes about 10 seconds.  Use the full path to the 'Patch' directory where you installed the Wildstar client.
        ```
        NexusForever.MapGenerator --i "D:\games\WildStar\Patch" --e
        ```
    * Generates a `map` directory in `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0`, takes about 10 minutes.   Use the full path to the 'Patch' directory where you installed the Wildstar client.
        ```
        NexusForever.MapGenerator --i "D:\games\WildStar\Patch" --g
        ```
11. Copy or move those generated `map` and `tbl` directories from `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0` to `NexusForever/Source/NexusForever.WorldServer/bin/Debug/net6.0/`

Now you are all setup to run the server.  

1. Make sure your docker container is running, if you stop it or reboot you will have to restart it.
    * Option 1: Use `docker-compose up` as in step 2 above
    * Option 2: Use Docker Desktop, click on 'Containers' on the left and you should see one named 'allinone', click the play button
    * Option 3: Start the container with `docker start allinone-wildstar-1` (name may be different?)
2. Open Visual Studio 2022 and open the solution `NexusForever/Source/NexusForever.sln`
3. These three projects need to be run:
    * AuthServer
    * StsServer
    * WorldServer
4. For running them you can:
    1. run the exe in the `bin/Debug/net6.0` directory under each
    2. Right-click on each project in Visual Studio and click `Debug->Start new instance`
    3. Right-click on the solution and select 'Properties'
        * go to 'Configure Startup Projects' and select 'Multiple Startup Projects
        * Change the Action for each of those three to 'Startup'
        * Then hitting F5 or using the green play button at the top will start all three projects at once

Now you're running and can create your account.   There should be a console
window with a title that starts with 'NexusForever: World Server'.  Activate
that window and you can type in [commands](https://www.emulator.ws/documentation/command-documentation)
after it finishes starting after a few minutes.   You'll know when it's started
because there will be a line like this near the bottom:

    [DEBUG][Host] Hosting started

Use this command (with your own email and password) to create an administrator (role 3) account that lets you enter
commands in the game chat with `/c [command] [parameters]` when connected.   Using the console directly you don't need to 
use the `/c` or `!` mentioned in the documentation, those only apply when used in game chat.

    account create myemail@example.com B@dP@55w0rd 3

Now you can connect to the game by running the `NexusForever.ClientConnector.exe` application you copied
to the `Client64` directory where you installed the Wildstar client in step 7 above.  The first time you
run it, it will as for the IP address.  Use `127.0.0.1` for localhost.  You can change this later by
editing the 'config.json' file in that diretory.

> NOTE: If you are running the server apps on a different server than the client, you will also have
to update the address in MySQL.   The AuthServer reports this ip to the client for connecting to a realm
after authentication.   Run this in your sql client, replacing the ip address with the one where
WorldServer is running of course.

```sql
select * from nexus_forever_auth.server;
update nexus_forever_auth.server set host = '192.168.17.12' where id = 1;
```

## Client Install

See [the client install guide](https://www.emulator.ws/installation/server-install-guide-windows).  If you are
crap at searching google, you could maybe try words like 'wildstar' and 'client'?   Just guessing...

When first starting it has to actually download and install all the data, so be ready for a long wait.
I've heard that if you want to use a language other than English, you should first install English anyway
to prevent some problems later.

## AdminUI

The AdminUI is very much a work in progress, a sort of front-end.   I may add
more options for managing accounts and such. in the future.   Right now I
find it useful for examining the tables using 'Explorer' at the top.  

It connects to the api running in the WorldServer and only serves on localhost
by default.   You can change 'WorldServer.json' to make it listen on 0.0.0.0
instead of 127.0.0.1 to open it up to your network, but there there is
currently no authentication setup for it so do that at your own risk.
You need to change the address of the api in `AdminUi/src/lib/Api.ts` also.

1. Make sure you have [NodeJS 22](https://nodejs.org/en/download/package-manager) installed
2. Install [pnpm](https://pnpm.io/installation)
3. Open a terminal and change to the `AdminUI` directory
4. Run:
    ```
    pnpm i
    ```
5. After doing that once, in the future you can just change to the `AdminUI` directory and run:
    ```
    pnpm dev --open
    ```
6. That should open your browser to `http://localhost:5173` and display the home page.

## A first change (you dirty cheater)

Go to NexusForever.WorldServer project in Visual Studio and navigate to
`Game/Combat` and open `DamageCalculator.cs`.   Go to line 45 where you see
this:

```cs
if (damage < 0)
    return;

if (victim == null || !victim.IsAlive)
    return;
```

Add these lines after, which will not add the damage if the victim is a
player, and will multiply the damage by 20 if the attacker is a player and
the victim is not:

```cs
if (victim is Player)
    return;

if (attacker is Player)
    damage *= 20;
```

Now when you start the WorldServer the game will be easier :)   I like adding
this when I'm just trying to explore and debug why quests aren't working
quickly.

You can edit the code while the server is running, but it seems like that only
works if the code is stopped in the method you are editing.   To try that out,
set a breakpoint on the previous statements and do something in-game to cause
damage.   Visual Studio should break at the method then you can make a change
and use CTRL+S to save and hit F5 to continue and the change will be used.
