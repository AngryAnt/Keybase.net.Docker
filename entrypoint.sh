#!/bin/bash

echo "Contents of entrypoint volume /var/keybase.net/:"
ls -al /var/keybase.net/
dotnet /var/keybase.net/$ENTRYPOINT
