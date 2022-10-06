(setq user-full-name "Phan Tan Thang"
      user-mail-address "thanglemon204@gmail.com"
      user-blog-url "https://github.com/thangsuperman")


;; You have to install the ef-thems first by using the command M-x: packages-install
;; (require 'ef-themes)
;; (load-theme 'ef-summer t)

;; Turn off the highlight current line
(setq global-hl-line-modes nil)

;; Mssql
(setq lsp-mssql-connections
      [(:server "localhost"
                :database ""
                :user "sa"
                :password "MyPassword123#")])

(require 'lsp-mssql)
(add-hook 'sql-mode-hook 'lsp)

;; Loading the lsp with lsp ui mode
(use-package! lsp-mode
  :commands lsp
  :hook (
         (rjsx-mode . lsp)
         (typescript-mode . lsp)
         ))

;; (use-package! lsp-mode
;;   :commands lsp
;;   :hook ((typescript-mode . lsp)))

(setq lsp-lens-enable nil)


;; Lsp solidity
(use-package! company-solidity
  :after (company))

(use-package! solidity-mode
  :config
  (setq format-all-mode nil))
(setq-hook! 'solidity-mode-hook +format-all-mode nil)

(add-hook 'solidity-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 (append '((company-solidity company-capf company-dabbrev-code))
                         company-backends))))
;; Company:1 ends here

;; [[file:config.org::*flycheck][flycheck:1]]
(use-package! solidity-flycheck
  :config
  (setq solidity-solc-path "~/usr/local/bin/solcjs")
  (setq solidity-solium-path "~/usr/local/bin/solium")
  (setq solidity-flycheck-solc-checker-active t)
  (setq solidity-flycheck-solium-checker-active t)
  (setq flycheck-solidity-solc-addstd-contracts t)
  (setq flycheck-solidity-solium-soliumrcfile "~/.soliumrc.json")
)

;; See https://github.com/ethereum/emacs-solidity#local-variables
(add-hook 'solidity-mode-hook
    (lambda ()
    (set (make-local-variable 'company-backends)
        (append '((company-solidity company-capf company-dabbrev-code))
            company-backends))))


;; My UX :)
(good-scroll-mode 1)

;; Yassnippet


;; (define-key evil-normal-state-map (kbd "C-c [") 'js2-err)
;; (define-key evil-normal-state-map (kbd "C-j") 'js2-next-error)

(define-key evil-normal-state-map (kbd "C-j") 'next-error)
(define-key evil-normal-state-map (kbd "C-k") 'previous-error)

;; [[file:config.org::*Clock][Clock:1]]
(after! doom-modeline
  (setq display-time-string-forms
        '((propertize (concat " 🕘 " 24-hours ":" minutes "   "))))
  (display-time-mode 1) ; Enable time in the mode-line

  ;; Add padding to the right
  (doom-modeline-def-modeline 'main
   '(bar workspace-name window-number modals matches follow buffer-info remote-host buffer-position word-count selection-info)
   '(objed-state misc-info persp-name battery grip irc mu4e gnus github debug repl lsp minor-modes input-method indent-info buffer-encoding major-mode process vcs checker "   ")))
;; Clock:1 ends here

;; [[file:config.org::*Battery][Battery:1]]
(after! doom-modeline
  (let ((battery-str (battery)))
    (unless (or (equal "Battery status not available" battery-str)
                (string-match-p (regexp-quote "unknown") battery-str)
                (string-match-p (regexp-quote "N/A") battery-str))
      (display-battery-mode 1))))
;; Battery:1 ends here

;; [[file:config.org::*Mode line customization][Mode line customization:1]]
(after! doom-modeline
  (setq doom-modeline-bar-width 4
        doom-modeline-mu4e t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-file-name-style 'truncate-upto-project))
;; Mode line customization:1 ends here

;; improve LSP
;; (after! lsp-mode
;;   (setq lsp-auto-guess-root t)
;;   (setq lsp-solargraph-symbols nil)
;;   (setq lsp-solargraph-folding nil))

;; (after! lsp-mode
;;   (setq lsp-disabled-clients '(emmet-ls))
;;   (setq lsp-ui-sideline-show-code-actions t))

;; Git blammer
(map!
        "C-c b"          #'blamer-mode)

(use-package blamer
  :bind (("s-i" . blamer-show-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 140
                    :italic t)))
  :config
  (global-blamer-mode 0))

(setq blamer-author-formatter " ✎ %s ")
(setq blamer-datetime-formatter "[%s]")
(setq blamer-commit-formatter " ● %s")

(map!
        ;; Command/Window
        "s-k"          #'move-text-up
        "s-j"          #'move-text-down)

(map!
        "s-p"          #'flycheck-previous-error
        "s-n"          #'flycheck-next-error)

;; Org styling, hide markup etc.
(setq org-hide-emphasis-markers t
      org-pretty-entities t
      org-ellipsis " ↩"
      org-hide-leading-stars t)

(setq doom-themes-treemacs-theme "doom-colors")

(map! :leader
      :n "SPC"  #'execute-extended-command
      :n "."  #'dired-jump
      :n ","  #'magit-status
      :n "-"  #'goto-line
      ;; (:prefix ("d" . "Debugger")
      ;;  :n    "r"   #'dap-debug
      ;;  :n    "l"   #'dap-debug-last
      ;;  :n    "R"   #'dap-debug-recent
      ;;  :n    "x"   #'dap-disconnect
      ;;  :n    "a"   #'dap-breakpoint-add
      ;;  :n    "t"   #'dap-breakpoint-toggle
      ;;  :n    "d"   #'dap-delete-session
      ;;  :n    "D"   #'dap-delete-all-sessions

      ;;  )

      (:prefix ("m" . "Treemacs")
       :n     "t"           #'treemacs
       :n     "df"           #'treemacs-delete-file
       :n     "dp"           #'treemacs-remove-project-from-workspace
       :n     "cd"           #'treemacs-create-dir
       :n     "cf"           #'treemacs-create-file
       :n     "a"           #'treemacs-add-project-to-workspace
       :n     "wc"           #'treemacs-create-workspace
       :n     "ws"           #'treemacs-switch-workspace
       :n     "wd"           #'treemacs-remove-workspace
       :n     "wf"           #'treemacs-rename-workspace
       )

)

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◆" "✸" "▶")
        org-modern-table-vertical 5
        org-modern-table-horizontal 2
        org-modern-list '((43 . "➤") (45 . "–") (42 . "•"))
        org-modern-footnote (cons nil (cadr org-script-display))
        org-modern-priority t
        org-modern-block t
        org-modern-block-fringe nil
        org-modern-horizontal-rule t
        org-modern-keyword
        '((t                     . t)
          ("title"               . "𝙏")
          ("subtitle"            . "𝙩")
          ("author"              . "𝘼")
          ("email"               . "@")
          ("date"                . "𝘿")
          ("lastmod"             . "✎")
          ("property"            . "☸")
          ("options"             . "⌥")
          ("startup"             . "⏻")
          ("macro"               . "𝓜")
          ("bind"                . #("" 0 1 (display (raise -0.1))))
          ("bibliography"        . "")
          ("print_bibliography"  . #("" 0 1 (display (raise -0.1))))
          ("cite_export"         . "⮭")
          ("print_glossary"      . #("ᴬᶻ" 0 1 (display (raise -0.1))))
          ("glossary_sources"    . #("" 0 1 (display (raise -0.14))))
          ("export_file_name"    . "⇒")
          ("include"             . "⇤")
          ("setupfile"           . "⇐")
          ("html_head"           . "🅷")
          ("html"                . "🅗")
          ("latex_class"         . "🄻")
          ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
          ("latex_header"        . "🅻")
          ("latex_header_extra"  . "🅻⁺")
          ("latex"               . "🅛")
          ("beamer_theme"        . "🄱")
          ("beamer_color_theme"  . #("🄱" 1 2 (display (raise -0.12))))
          ("beamer_font_theme"   . "🄱𝐀")
          ("beamer_header"       . "🅱")
          ("beamer"              . "🅑")
          ("attr_latex"          . "🄛")
          ("attr_html"           . "🄗")
          ("attr_org"            . "⒪")
          ("name"                . "⁍")
          ("header"              . "›")
          ("caption"             . "☰")
          ("language"            . "𝙇")
          ("hugo_base_dir"       . "𝐇")
          ("latex_compiler"      . "⟾")
          ("results"             . "🠶")
          ("filetags"            . "#")
          ("created"             . "⏱")
          ("export_select_tags"  . "✔")
          ("export_exclude_tags" . "❌")))
)

;; Research on the internet (Youtube, google, ...)
(use-package engine-mode
  :config
  (engine/set-keymap-prefix (kbd "C-c s"))
  (setq browse-url-browser-function 'browse-url-default-macosx-browser
        engine/browser-function 'browse-url-default-macosx-browser
        ;; browse-url-generic-program "google-chrome"
        )
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")

  (defengine github
    ;; "https://github.com/search?ref=simplesearch&q=%s"
    "https://github.com/%s"
    :keybinding "1")

  (defengine gitlab
    "https://gitlab.com/search?search=%s&group_id=&project_id=&snippets=false&repository_ref=&nav_source=navbar"
    :keybinding "2")

  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "s")

  (defengine npm
    "https://www.npmjs.com/search?q=%s"
    :keybinding "n")

  (defengine crates
    "https://crates.io/search?q=%s"
    :keybinding "c")

  (defengine localhost
    "http://localhost:%s"
    :keybinding "l")

  (defengine youtube
    "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
    :keybinding "y")

  (defengine google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "g")

  (engine-mode 1))

(setq fancy-splash-image "~/Downloads/baby-yoda.gif")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Hack Nerd Font" :size 16 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Hack Nerd Font" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-solarized-dark)
;; (setq doom-theme 'doom-solarized-light-high-contrast)
;; (setq doom-theme 'doom-dracula)


;; Manual install
;; git clone https://git.sr.ht/~theorytoe/everforest-theme ~/.emacs.d/everforest-theme
(setq doom-theme 'everforest-hard-dark)



;; (use-package ef-themes)
;; (load-theme 'ef-summer t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new key
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
