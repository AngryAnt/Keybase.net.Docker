# Keybase and .net core Docker setup

This Docker configuration launches & authenticates Keybase and a specified .net core program - initially intended for use with Keybase.net.

## Configuration
 - Volume `/var/keybase.net/` mapped to where the target .net core program is located.
 - Environment variable `ENTRYPOINT`: Name of the .net core program to run - by default "program.dll".
 - Environment variable `KEYBASE_USERNAME`: Keybase use to sign in as.
 - Environment variable `KEYBASE_PAPERKEY`: Valid paperkey for the specified `KEYBASE_USERNAME`.
