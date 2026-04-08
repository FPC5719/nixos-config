;; init.el

;; Basic settings
(setq confirm-kill-emacs #'yes-or-no-p)
(electric-pair-mode t)
(add-hook 'prog-mode-hook #'show-paren-mode)
(column-number-mode t)
(global-auto-revert-mode t)
(delete-selection-mode t)
(setq inhibit-startup-message t)
(setq make-backup-files nil)
; (add-hook 'prog-mode-hook #'hs-minor-mode)
(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(when (display-graphic-p) (toggle-scroll-bar -1))
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)
(setq tab-width 2)

; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
; (load custom-file t)

(eval-when-compile
  (require 'use-package))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-basic)
(require 'init-lang)
(require 'init-tex)

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((hls-env
      . "/nix/store/5wv2x92vax7kcjdq9hzw8vbs4rp3y4xp-haskell-language-server-2.12.0.0/bin/haskell-language-server-wrapper")
     (cxx-env
      . "/nix/store/myvv172x2am72534zgn9wx0qp5amq6a8-gcc-wrapper-14.3.0/bin/g++")
     (eval run-with-idle-timer 0.1 nil
           (lambda nil
             (when (bound-and-true-p lsp-mode)
               (lsp-mode -1) (lsp-managed-mode -1))
             (flymake-mode -1))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-variable-obsolete ((t (:foreground "blue"))))
 '(custom-variable-tag ((t (:foreground "blue" :weight bold))))
 '(font-latex-bold-face ((t (:inherit bold :foreground "green"))))
 '(font-latex-italic-face ((t (:inherit italic :foreground "green"))))
 '(font-latex-math-face ((t (:inherit italic :foreground "yellow"))))
 '(font-latex-sectioning-5-face ((t (:foreground "blue" :weight bold))))
 '(font-latex-underline-face ((t (:inherit underline :foreground "green"))))
 '(font-latex-verbatim-face ((t (:inherit fixed-pitch :foreground "yellow"))))
 '(font-lock-builtin-face ((t (:foreground "dark slate blue" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "brightblack"))))
 '(font-lock-constant-face ((t (:foreground "green"))))
 '(font-lock-function-name-face ((t (:foreground "blue"))))
 '(font-lock-keyword-face ((t (:foreground "magenta" :slant italic))))
 '(font-lock-string-face ((t (:foreground "yellow"))))
 '(font-lock-type-face ((t (:foreground "green"))))
 '(font-lock-variable-name-face ((t (:foreground "cyan"))))
 '(highlight ((t (:background "brightblack"))))
 '(lazy-highlight ((t (:background "brightblue"))))
 '(lsp-headerline-breadcrumb-path-face ((t (:foreground "magenta"))))
 '(lsp-headerline-breadcrumb-path-hint-face ((t (:foreground "magenta" :underline (:color "Green" :style wave :position nil)))))
 '(lsp-headerline-breadcrumb-path-info-face ((t (:foreground "magenta" :underline (:color "Green" :style wave :position nil)))))
 '(lsp-headerline-breadcrumb-path-warning-face ((t (:foreground "magenta" :underline (:color "Yellow" :style wave :position nil)))))
 '(lsp-headerline-breadcrumb-project-prefix-face ((t (:foreground "magenta" :weight bold))))
 '(lsp-headerline-breadcrumb-symbols-face ((t (:foreground "magenta" :weight bold))))
 '(match ((t (:background "yellow"))))
 '(minibuffer-prompt ((t (:foreground "blue"))))
 '(mode-line ((t (:background "white" :foreground "black" :box (:line-width (1 . -1) :style released-button)))))
 '(region ((t (:extend t :background "brightblack"))))
 '(show-paren-match ((t (:background "brightblack")))))
