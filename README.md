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

## Prerequisites

1. [Docker](https://www.docker.com/)
2. [Visual Studio 2022](https://visualstudio.microsoft.com/vs/community/)
3. [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) or other tool for connecting to MySQL
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
3. Using MySQL Workbench or some other tool that allows running MySQL scripts:
    1. Connect to `127.0.0.1` as the user `root` with the password `DisIssssR00t` (or whatever you set in the `docker-compose.yml` file)
    2. Run the commands in [init.sql](init.sql) to setup the three databases and the `nexusforever` user
    3. Change to the world database with the command:
        ```
        use nexus_forever_world;
        ```
    4. Run the script in `WorldDatabase/All in one/All in one.sql` to populate the database
4. Open Visual Studio 2022 and open the solution `NexusForever/Source/NexusForever.sln`
    * Use CTRL+SHIFT+B to build all the projects
    * You should see they were all successfully built
5. Rename these files to remove the '.example' from them:
    * `NexusForever/Source/NexusForever.AuthServer/bin/Debug/net6.0/AuthServer.example.json`
    * `NexusForever/Source/NexusForever.StsServer/bin/Debug/net6.0/StsServer.example.json`
    * `NexusForever/Source/NexusForever.WorldServer/bin/Debug/net6.0/WorldServer.example.json`
6. Make sure you have the client installed with data downloaded and know the path to it (see below)
    * My path is `D:\Games\Wildstar`, which has 'Wildstart.exe' and the folders 'bootstrap', 'Client64', 'Errors', 'Launcher', and 'Patch' in it
7. Copy all the files in `NexusForever/Source/NexusForever.ClientConnector/bin/Debug/net6.0` to the 'Client64' directory where you installed Wildstar
    * You will start the game using `Client64/NexusForever.ClientConnector.exe` instead of Wildstar.exe
8. Open a terminal and go to `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0` and run these commands:
    * Generates a 'tbl' directory in `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0`, takes about 10 seconds.  Use the full path to the 'Patch' directory where you installed the Wildstar client.
        ```
        NexusForever.MapGenerator --i "D:\games\WildStar\Patch" --e
        ```
    * Generates a `map` directory in `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0`, takes about 10 minutes.   Use the full path to the 'Patch' directory where you installed the Wildstar client.
        ```
        NexusForever.MapGenerator --i "D:\games\WildStar\Patch" --g
        ```
9. Copy or move those generated `map` and `tbl` directories from `NexusForever/Source/NexusForever.MapGenerator/bin/Debug/net6.0` to `NexusForever/Source/NexusForever.WorldServer/bin/Debug/net6.0/`

Now you are all setup to run the server.  If you shut down the docker container running MySQL or reboot you will have to start it again.

1. Open Visual Studio 2022 and open the solution `NexusForever/Source/NexusForever.sln`
2. The first time WorldServer is run it will do database migrations, so you may want to run it first by itself to create the tables accessed in the other two:
    * Right-click on the NexusForever.WorldServer project and go to Debug (a little more than 1/2 way down) and select 'Start new instance'
    * Wait for migrations to happen (The game will be completely started when you see '`[DEBUG][Host] Hosting started`' in the log)
    * Use CTRL+C in the console window or hit the stop button in visual studio to stop the server
3. These three projects should be set to all start when you press 'F5' or hit the play button, so do so and you should see three console windows appear for the apps:
    * AuthServer
    * StsServer
    * WorldServer
    
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
run it, it will as for the IP address.   Use '127.0.0.1' for localhost.

## Client Install

See [the client install guide](https://www.emulator.ws/installation/server-install-guide-windows).  If you are
crap at searching google, you could maybe try words like 'wildstar' and 'client'?   Just guessing...

When first starting it has to actually download and install all the data, so be ready for a long wait.
I've heard that if you want to use a language other than English, you should first install English anyway
to prevent some problems btw.

### AdminUI

The AdminUI is very much a work in progress.   If you wish to use it to examine some of the
game data using the 'Explorer':

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
