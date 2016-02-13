(require 'cl)
(setq exec-path (cons "/usr/local/bin"exec-path))

(tool-bar-mode 0)
(scroll-bar-mode 0)

(defvar user-emacs-directory "~/.emacs.d/")

(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
;; 初期化
(package-initialize)

(defvar my-package-list
  '(
    ac-cider
    ace-isearch
    ace-jump-mode
    ace-link
    ace-window
    adaptive-wrap
    aggressive-indent
    anzu
    ;;archives
    async
    atom-dark-theme
    atom-one-dark-theme
    auto-complete
    auto-dictionary
    auto-highlight-symbol
    avy
    bind-key
    browse-url-dwim
    buffer-move
    ccc
    cdb
    cider
    clean-aindent-mode
    clojure-cheatsheet
    clojure-mode
    coffee-mode
    csv-mode
    dash
    ddskk
    deferred
    define-word
    diminish
    dired+
    dired-avfs
    dired-details+
    dired-details
    dired-dups
    dired-efap
    dired-fdclone
    dired-filter
    dired-hacks-utils
    dired-imenu
    dired-k
    dired-open
    dired-rainbow
    dired-ranger
    dired-single
    dired-sort
    dired-sort-menu+
    dired-sort-menu
    dired-subtree
    dired-toggle
    direx
    direx-grep
    dirtree
    elisp-slime-nav
    elscreen
    elscreen-persist
    epl
    espresso-theme
    eval-sexp-fu
    exec-path-from-shell
    expand-region
    fancy-battery
    fill-column-indicator
    flx
    flx-ido
    flycheck
    flymake-easy
    flymake-php
    ;git-commit-mod
    ;git-rebase-mode
    ;gnupg
    go-eldoc
    go-mode
    golden-ratio
    google-translate
    goto-chg
    haml-mode
    helm
    helm-ag
    helm-core
    helm-descbinds
    helm-make
    helm-migemo
    helm-mode-manager
    helm-projectile
    helm-rails
    helm-swoop
    helm-themes
    highlight
    highlight-indentation
    highlight-numbers
    highlight-parentheses
    ht
    hungry-delete
    hydra
    ido-vertical-mode
    iedit
    indent-guide
    inflections
    info+
    init-loader
    let-alist
    leuven-theme
    linum-relative
    list-utils
    macrostep
    magit
    markdown-mode
    migemo
    monokai-theme
    move-text
    multi-eshell
    neotree
    open-junk-file
    osx-browse
    package-build
    page-break-lines
    pager
    paradox
    parent-mode
    pcre2el
    php-mode
    pkg-info
    popup
    popwin
    powerline
    projectile
    pyflakes
    pymacs
    python-environment
    python-mode
    quelpa
    queue
    rainbow-delimiters
    redo+
    revive
    s
    sass-mode
    sbt-mode
    scala-mode2
    seq
    shell-pop
    slamhound
    smartparens
    smooth-scrolling
    spacemacs-theme
    sparql-mode
    spinner
    spray
    ssh-agency
    ssh-file-modes
    string-utils
    swoop
    tree-mode
    undo-tree
    use-package
    vi-tilde-fringe
    volatile-highlights
    web-mode
    which-key
    windata
    window-jump
    window-numbering
    yasnippet
    yatex
    zenburn
    zenburn-theme
    
  ))

(let ((not-installed
       (loop for package in my-package-list
             when (not (package-installed-p package))
             collect package)))
  (when not-installed
    (package-refresh-contents)
    (dolist (package not-installed)
      (package-install package))))


(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
	backup-directory-alist))



(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "clone-package" "themes" "elpa")

(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")


;; load environment value
(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

(server-start)
