;; --- Setup package management ---
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Always download missing packages
(setq use-package-always-ensure t)


;; --- Install and configure packages ---
;; Set theme
(use-package color-theme-sanityinc-tomorrow
  :config
  (setq custom-safe-themes t)
  (color-theme-sanityinc-tomorrow-night))

;; Clipboard interaction in terminal Emacs
(use-package simpleclip
  :bind (("C-c c" . simpleclip-copy)
         ("C-c v" . simpleclip-paste)
         ("C-c x" . simpleclip-cut)))

;; Evil
(use-package evil
  :init
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode t)
  (define-key evil-normal-state-map (kbd "q") nil)
  (define-key evil-normal-state-map (kbd "U") 'undo-tree-redo)
  (define-key evil-normal-state-map (kbd "Y") 'jsb/copy-to-end-of-line)
  (define-key evil-normal-state-map (kbd "g x") 'browse-url-at-point)

  (define-key evil-normal-state-map (kbd "[ SPC") 'jsb/insert-line-above)
  (define-key evil-normal-state-map (kbd "] SPC") 'jsb/insert-line-below)

  ;; Bring back some emacs bindings in insert mode
  (define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
  (define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
  (define-key evil-insert-state-map (kbd "C-d") 'delete-char)

  (use-package evil-leader
    :config
    (global-evil-leader-mode)
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key
      "p" 'helm-projectile))

  (use-package evil-surround
    :config (global-evil-surround-mode t))

  (use-package evil-commentary
    :diminish evil-commentary-mode
    :config (evil-commentary-mode))

  (use-package evil-visualstar
    :config (global-evil-visualstar-mode)))

(use-package magit
  :bind (("C-c g" . magit-status))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(use-package gitconfig-mode
  :config
  (add-to-list 'auto-mode-alist '("gitconfig" . gitconfig-mode)))

(use-package github-browse-file)

(use-package git-gutter
  :config
  (global-git-gutter-mode t)
  (git-gutter:linum-setup)
  (setq git-gutter:modified-sign "~")
  (define-key evil-normal-state-map (kbd "[ h") 'git-gutter:previous-hunk)
  (define-key evil-normal-state-map (kbd "] h") 'git-gutter:next-hunk))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this))

(use-package org
  :config
  (setq org-log-done t)
  (setq org-hide-leading-stars t)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w)" "IN-PROGRESS(i)" "|" "DONE(d)")))
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "red" :weight bold))
          ("WAITING" . (:foreground "orange" :weight bold))
          ("IN-PROGRESS" . (:foreground "sky" :weight bold))))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ruby . t))))

(use-package helm
  :diminish helm-mode
  :config
  (progn
    (require 'helm-config)
    (helm-mode t)
    (helm-autoresize-mode t)
    (setq helm-mode-fuzzy-match t)
    (setq helm-completion-in-region-fuzzy-match t)
    (setq helm-M-x-fuzzy-match t))
  :bind
  (("M-x" . helm-M-x)))

(use-package helm-projectile
  :config
  (helm-projectile-on))

(use-package helm-ag)

(use-package projectile
  :config
  (projectile-global-mode))

;; Make zooming in GUI Emacs work the same as in terminal
(use-package zoom-frm
  :config
  (global-set-key (kbd "s--") 'zoom-out)
  (global-set-key (kbd "s-=") 'zoom-in))

(use-package eshell
  :config
  (setq eshell-scroll-to-bottom-on-input t))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package smartparens
  :config
  (require 'smartparens-config)

  ;; Elixir
  (sp-with-modes '(elixir-mode)
    (sp-local-pair "fn" "end"
		   :when '(("SPC" "RET"))
		   :actions '(insert navigate))
    (sp-local-pair "do" "end"
		   :when '(("SPC" "RET"))
		   :post-handlers '(sp-ruby-def-post-handler)
		   :actions '(insert navigate))))

(use-package auto-complete)

;; Language packages

(use-package markdown-mode)

(use-package web-mode)

(use-package enh-ruby-mode
  :config
  (add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
  ;; Use system Ruby to work on 1.8 as well
  (setq enh-ruby-program "/usr/bin/ruby"))

(use-package rust-mode
  :config
  ;; cargo install rustfmt
  (add-hook 'rust-mode-hook #'rust-enable-format-on-save)

  (use-package cargo
    :config
    (add-hook 'rust-mode-hook 'cargo-minor-mode)))

(use-package go-mode
  :config
  ;; To install all the go tools:
  ;; go get golang.org/x/tools/cmd/...

  ;; go get golang.org/x/tools/cmd/goimports
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)

  ;; go get golang.org/x/tools/cmd/guru
  (use-package go-guru
    :config
    (add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)
    (set-face-attribute 'go-guru-hl-identifier-face nil :background "brightblack"))

  ;; go get golang.org/x/tools/cmd/gorename
  (use-package go-rename)

  ;; go get github.com/nsf/gocode
  (use-package go-autocomplete
    :config
    (require 'auto-complete-config)
    (ac-config-default)))

(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package elixir-mode)
(use-package alchemist)

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package groovy-mode
  :config
  (add-to-list 'auto-mode-alist '("Jenkinsfile" . groovy-mode)))

;; --- Settings ---
;; Read this file as elisp
(add-to-list 'auto-mode-alist '("emacs" . emacs-lisp-mode))

(set-face-attribute 'default nil :font "Monaco")

;; Whitespace
(setq require-final-newline t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq sentence-end-double-space nil)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)

;; Turn off ugly GUI stuff
(menu-bar-mode -1)
(if (display-graphic-p)
  (progn
    (tool-bar-mode -1)
    (scroll-bar-mode -1)))

;; Enable Cmd key as Super(s)
(setq mac-command-modifier 'super)

;; Toggle full screen mode with Cmd-RET
(global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

;; Enable mouse scrolling in terminal emacs
(xterm-mouse-mode)
(global-set-key (kbd "<mouse-5>") 'evil-scroll-line-down)
(global-set-key (kbd "<mouse-4>") 'evil-scroll-line-up)

;; Don't ring the bell
(setq ring-bell-function 'ignore)

;; Non-blinking cursor
(blink-cursor-mode 0)

;; Turn off wrapping by default
(setq-default truncate-lines t)

;; Start calendar on Monday
(setq calendar-week-start-day 1)

;; Automatically update changed files
(global-auto-revert-mode t)
(diminish 'auto-revert-mode)

;; Always ask y/n instead of typing out the full word
(defalias 'yes-or-no-p 'y-or-n-p)

;; Allow usage of more memory before calling GC
(setq gc-cons-threshold 20000000)

;; Save backups in the temp directory instead of next to the file
(setq backup-directory-alist
    `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
    `((".*" ,temporary-file-directory t)))

;; Turn off vc
(setq vc-handled-backends ())

;; Enable line numbers
(global-linum-mode t)
(setq linum-format " %d ")

;; IDO mode
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

;; Disable the splash screen
(setq inhibit-startup-message t
      initial-scratch-message nil)

;; Show human readable sizes in dired
(setq-default dired-listing-switches "-alh")

;; Autocomplete pairs of brackets by default
(electric-pair-mode)

;; Visually indicate matching pairs of parentheses.
(show-paren-mode t)
(setq show-paren-delay 0.0)

;; --- Keybindings ---
(global-set-key (kbd "C-x 2") 'jsb/split-window-below-and-switch)
(global-set-key (kbd "C-x 3") 'jsb/split-window-right-and-switch)

;; Toggle word wrapping
(global-set-key (kbd "C-c w") 'toggle-truncate-lines)

;; Enable shell-script-mode quickly in files that aren't detected as shell script files
(global-set-key (kbd "C-c s") 'shell-script-mode)

;; --- Utility functions ---
(defun jsb/split-window-below-and-switch ()
  "Split the window below, then switch to the new pane."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun jsb/split-window-right-and-switch ()
  "Split the window right, then switch to the new pane."
  (interactive)
  (split-window-right)
  (other-window 1))

(defun jsb/copy-to-end-of-line ()
  (interactive)
  (evil-yank (point) (point-at-eol)))

(defun jsb/insert-line-above ()
  (interactive)
  (evil-insert-newline-above)
  (forward-line))

(defun jsb/insert-line-below ()
  (interactive)
  (evil-insert-newline-below)
  (forward-line -1))
