
$packages = @(
    'xb1cbi',
    'electronmail',
    'irfanview',
    'lessmsi',
    'mobaxterm',
    'notepadplusplus',
    'paint.net',
    'tightvnc',
    'treesize-free',
    'vlc',
    'discord',
    'steam',
    'lively',
    'soundswitch'
)

$packages | ForEach-Object{ scoop install $_ }

npm install --global markdownlint-cli