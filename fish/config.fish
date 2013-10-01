if status --is-login

    # Fish reassigns $fish_greeting if it is not set so we can't do -e.
    set fish_greeting ""

    # General bin paths
    set PATH /usr/local/sbin $PATH
    set PATH /usr/local/bin $PATH
    set PATH $HOME/.local/bin $PATH
    set PATH $HOME/.dotfiles/bin $PATH

    # Ruby-specific configurations
    if test -d $HOME/.rbenv
        set PATH $HOME/.rbenv/bin $PATH
        set PATH $HOME/.rbenv/shims $PATH
        rbenv rehash >/dev/null
    end

    # Python-specific configurations
    if test -d $HOME/.virtualenvs
        virtualenv activate default
    end

    # Node-specific configurations
    if test -d /usr/local/share/npm/
        set PATH /usr/local/share/npm/bin $PATH
    end

    # EC2-specific paths
    if test -d $HOME/.ec2
        set EC2_PRIVATE_KEY (/bin/ls $HOME/.ec2/pk-*.pem)
        set EC2_CERT (/bin/ls $HOME/.ec2/cert-*.pem)
        set EC2_KEYPAIR (/bin/ls $HOME/.ec2/ec2-*.pem)
    end

    if test -d /Applications/VMware\ Fusion.app
        function vmrun
            /Applications/VMware\ Fusion.app/Contents/Library/vmrun $argv
        end
    end

    # Aliases
    function intellij; open -b com.jetbrains.intellij $argv; end
    if which hub 2>&1 >/dev/null
        function git; hub $argv; end
    end

end
