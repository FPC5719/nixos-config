;; Language highlights and toolchains

(defun my-c-mode-hook ()
  (add-hook
   'hack-local-variables-hook
   (lambda ()
     (message "Enter C hook with ENV")
     (let ((cc-path  (if (boundp 'cc-env)  cc-env  "/run/current-system/bin/gcc"))
           (cxx-path (if (boundp 'cxx-env) cxx-env "/run/current-system/bin/g++")))
       (message "cc-path: %s" cc-path)
       (message "cxx-path: %s" cxx-path)
       (require 'lsp-clangd)
       (setq lsp-clients-clangd-args
             (list "--header-insertion-decorators=0"
                   (concat "--query-driver=" cc-path  "," cxx-path)))
       (lsp-deferred)))
   nil t))

(use-package lsp-mode
  :defer t
  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 50)
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (c-mode . my-c-mode-hook)
  (c++-mode . my-c-mode-hook)
  :config
  (setq lsp-enable-on-type-formatting nil)
  (require 'lsp-clangd)
  (setq lsp-clients-clangd-executable "/run/current-system/sw/bin/clangd")
  :bind
  ("C-c l s" . lsp-ivy-workspace-symbol))
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.lake\\'"))

(use-package lsp-ivy
  :after (lsp-mode))

(add-hook 'flymake-mode-hook
          (lambda ()
            (local-set-key (kbd "M-p") 'flymake-goto-prev-error)
            (local-set-key (kbd "M-n") 'flymake-goto-next-error)
            (local-set-key (kbd "M-m") 'flymake-show-buffer-diagnostics)))

(use-package projectile
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil))

(use-package counsel-projectile
  :after (projectile)
  :init (counsel-projectile-mode))

(use-package verilog-mode
  :defer t
  :config
  (setq verilog-indent-level 4)
  (setq verilog-indent-level-module 4)
  (setq verilog-indent-level-directive 0)
  (setq verilog-indent-level-behavioral 0)
  (setq verilog-indent-level-declaration 4)
  (setq verilog-auto-newline nil))

(add-hook 'asm-mode-hook
          (lambda ()
            (setq asm-comment-char 35)))

(use-package nix-mode
  :mode "\\.nix\\'")

;; Haskell
(defun my-company ()
  (set (make-local-variable 'company-backends)
       (append '((company-capf company-dabbrev-code))
               company-backends)))

(use-package lsp-haskell
  :defer t)

(defun my-haskell-mode-hook ()
  (add-hook
   'hack-local-variables-hook
   (lambda ()
     (let ((hls-path (if (boundp 'hls-env) hls-env "haskell-language-server-wrapper")))
       (message "hls-path: %s" hls-path)
       (setq lsp-haskell-server-path hls-path))
     (lsp-deferred))
   nil t))

(use-package haskell-mode
  :defer t
  :config
  (setq haskell-tags-on-save t)
  (setq tags-revert-without-query t)
  :hook
  ; ((haskell-mode . my-company))
  ; (haskell-mode . my-haskell-mode-hook)
  (haskell-mode . lsp-deferred)
  )
;; Haskell END

;; Scala
(use-package lsp-metals
  :after lsp-mode
  :config
  (lsp-register-custom-settings
   '(("metals.preferredBuildTool" "mill")
     ("metals.serverProperties" ("-J-Xmx4G")))))

(use-package scala-mode
  :defer t
  :mode "\\.scala\\'"
  :interpreter ("scala" . scala-mode)
  :hook (scala-mode . lsp-deferred))
;; Scala END

;; Lean
(use-package dash
  :defer t)
(use-package magit-section
  :defer t)
; (use-package lean4-mode
;   :load-path "~/.emacs.d/my-pkgs/lean4-mode/")
;; Lean END

; (use-package koka-mode
;   :load-path "~/.emacs.d/my-pkgs/")

(provide 'init-lang)
