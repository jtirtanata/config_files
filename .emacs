;; Startup Optimisation
(setq gc-cons-threshold 100000000)

(require 'package)


(add-to-list 'package-archives '("org"          . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa"        . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; Packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(eval-when-compile
  (require 'use-package))

(setq evil-want-C-i-jump nil)
(use-package evil :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-search-module 'evil-search)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up-then-center)
  (define-key evil-normal-state-map (kbd "C-d") 'evil-scroll-down-then-center)
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  (define-key evil-visual-state-map (kbd ">") 'better-evil-shift-right)
  (define-key evil-visual-state-map (kbd "<") 'better-evil-shift-left)
  (advice-add 'evil-search-next :after #'my-center-line))

(defun evil-scroll-up-then-center (count)
  (interactive "P")
  (evil-scroll-up count)
  (evil-scroll-line-to-center count))

(defun evil-scroll-down-then-center (count)
  (interactive "P")
  (evil-scroll-down count)
  (evil-scroll-line-to-center count))

(use-package evil-collection :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary :ensure t)
(require 'evil-commentary)
(evil-commentary-mode)

;;;; Emacs Lisp
(use-package paredit :ensure t)
(use-package lispy :ensure t)
(use-package smart-tabs-mode :ensure t)
(use-package smart-yank :ensure t)
(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :diminish (parinfer-mode . "")
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
             pretty-parens  ; different paren styles for different modes.
             evil           ; If you use Evil.
             lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
             paredit        ; Introduce some paredit commands.
             smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
             smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))
(add-hook 'lisp-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))

(use-package rainbow-delimiters :ensure t
  :init (rainbow-delimiters-mode))

(use-package monokai-theme :ensure t)
(load-theme 'monokai t)

(use-package tmux-pane :ensure t)
(require 'tmux-pane)
(tmux-pane-mode t)

(use-package linum-relative :ensure t
  :init
  (setq linum-relative-backend 'display-line-numbers-mode)
  (global-display-line-numbers-mode)
  (set-face-background 'line-number "unspecified-bg"))
(require 'linum-relative)
(linum-relative-on)

(global-display-line-numbers-mode)

(use-package general :ensure t
  :config
  (general-evil-setup t)

  ;; Clojure
  (general-define-key
   :states '(normal visual)
   :keymaps 'clojure-mode-map
   :prefix "SPC"
   :non-normal-prefix "C-s"
   "cj" '(cider-jack-in :which-key "jack in")
   "cl" '(cider-load-buffer :which-key "load buffer")
   "cc" '(cider-connect :which-key "connect")
   "cn" '(cider-repl-set-ns :which-key "set repl ns")
   "ct" '(cider-test-run-test :which-key "run test")
   "cb" '(cider-switch-to-repl-buffer :which "repl buffer")
   "cd" '(cider-doc :which-key "doc")
   "cf" '(cider-find-var :which-key "find var")
   "cp" '(cider-pop-back :which-key "pop back")
   "ces" '(cider-eval-sexp-at-point :which-key "eval sexp")
   "cet" '(cider-eval-defun-at-point :which-key "eval top")
   "cer" '(cider-eval-region :which-key "eval region")
   "p(" '(paredit-wrap-round :which-key "wrap (")
   "p[" '(paredit-wrap-square :which-key "wrap [")
   "p{" '(paredit-wrap-curly :which-key "wrap {")
   "pk" '(paredit-kill :which-key "paredit kill")
   "ps" '(paredit-forward-slurp-sexp :which-key "forward slurp")
   "pb" '(paredit-forward-barf-sexp :which-key "forward barf")
   "pS" '(paredit-backward-slurp-sexp :which-key "backward slurp")
   "pB" '(paredit-backward-barf-sexp :which-key "backward barf")
   "ps" '(paredit-split-sexp :which-key "split sexp")
   "pj" '(paredit-join-sexps :which-key "join sexps")
   "SPC l" '(paredit-forward-down :which-key "paredit forward")
   "SPC h" '(paredit-backward-up :which-key "paredit backward")
   "pt" '(transpose-sexps :which-key "transpose sexps")
   "pT" '(reverse-transpose-sexps :which-key "reverse transpose sexps"))

  (general-define-key
   :states '(normal)
   :keymaps 'clojure-mode-map
   :prefix "C-c"
   "C-c" '(cider-eval-defun-at-point :which-key "eval top level"))

  (general-define-key
   :states '(visual)
   :keymaps 'clojure-mode-map
   :prefix "C-c"
   "C-c" '(cider-eval-region :which-key "eval region"))

  (general-define-key
   :states '(normal)
   :keymaps 'cider-repl-mode-map
   :prefix "SPC"
   "n" '(cider-repl-next-input :which-key "repl next")
   "p" '(cider-repl-previous-input :which-key "repl previous")
   "cb" '(cider-repl-clear-buffer :which-key "clear buffer")
   "co" '(cider-repl-clear-output :which-key "clear output")))

(use-package xclip :ensure t)
(xclip-mode 1)

;;;; Clojure
(use-package clojure-mode :ensure t)
(use-package cider :ensure t
  :pin melpa-stable
  :config
  (setq nrepl-hide-special-buffers t)
  (setq cider-repl-pop-to-buffer-on-connect 'display-only))

(use-package xclip :ensure t)
(xclip-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (monokai-theme rainbow-delimiters parinfer smart-yank smart-tabs-mode lispy paredit evil-commentary evil-collection evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

