#!/usr/bin/env bash
set -u
DFOfficialURL="http://www.bay12games.com/dwarves/"
DFDirectory="$(pwd)"
DFFinalDir="$DFDirectory/df_linux"
if [[ ! -w "$DFDirectory" ]]
then
  echo "S'rry m'lord, path $DFDirectory is sturdy.. can't dig or write there"
  exit 1
fi 
oldVersionFile="$DFDirectory/latestVersion"
oldVersion=''
if [[ -r "$oldVersionFile" ]]
then
  oldVersion="$(cat $oldVersionFile)"
fi
oldVersionDir="$DFDirectory/$oldVersion"

echo 'Fetching Latest Remote version Info...'
latestRemoteArchive="$(curl -ks $DFOfficialURL | gawk 'match($0, /\W(df_.*linux.tar.bz2)\W/, res) {print res[1]}')"
latestLocalDir="$(echo $latestRemoteArchive | sed 's/^\(.*\)\.tar\.bz2$/\1/i')"
if [[ "$oldVersion" == "$latestLocalDir" ]]
then
  echo "You yet haz da lAteST verSHIoN, m'lord"
  exit 0
fi

if [[ -w $oldVersion ]]
then
  mv "$DFFinalDir" "$oldVersionDir"  
fi

latestLocalArchive="$DFDirectory/""$latestRemoteArchive"
latestRemoteURL="$DFOfficialURL""$latestRemoteArchive"
echo "Downloading latest archive..."
curl -kq "$latestRemoteURL" > "$latestLocalArchive"

mkdir "$latestLocalDir"
echo "Extracting latest archive..."
tar -qxjf "$latestLocalArchive"

DFLatestExec="$DFFinalDir/df"
if [[ -x $DFLatestExec ]] 
then
  echo "Cleaning old stuff..."
  echo "$latestLocalDir" > "$oldVersionFile"
  rmdir "$latestLocalDir" 
fi
