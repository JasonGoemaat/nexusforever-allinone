CREATE USER nexusforever IDENTIFIED BY 'nexusforever';
CREATE DATABASE nexus_forever_auth;
CREATE DATABASE nexus_forever_character;
CREATE DATABASE nexus_forever_world;
GRANT ALL PRIVILEGES ON nexus_forever_auth.* TO nexusforever;
GRANT ALL PRIVILEGES ON nexus_forever_character.* TO nexusforever;
GRANT ALL PRIVILEGES ON nexus_forever_world.* TO nexusforever;
