
# Configure identity
git config --global user.name "Richtman, Ariel"
git config --global user.email "10679234+arichtman@users.noreply.github.com"

# Enable git's automagic
git config --global rerere.enabled true
git config --global help.autocorrect 10

# Create key if we don't have one
# gpg --full-generate-key
# Get key ID and set up to autosign
gpg --list-secret-keys --keyid-format=long
git config --global user.signingKey $KEY
git config --global commit.gpgSign true
# This config is required for Powershell signing to work, otherwise error "No secret key"
$gpgPath = which gpg
git config --global gpg.program $gpgPath

# Cache credentials for HTTPS
git config --global credential.helper "cache --timeout=3600"

# Set up global, unversioned ignore file
git config --global core.excludesfile ~/.gitignore
printf "*~\n.env\n.cache\n.vaultpass" > ~/.gitignore_global

# Pretty sure these QoLs come pre-enabled but nice to be sure
git config --global color.ui true
git config --global core.autocrlf input
