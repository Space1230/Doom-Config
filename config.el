;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(package-initialize)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Andy Sparks"
      user-mail-address "andrewtsparks@icloud.com")

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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-capture-notes-file "my-notes.org") ; required because "notes.org" is used for CSS styling and exports

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
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Smudge Config
;; https://github.com/danielfm/smudge
(load! "spotify-secrets.el") ; this file contains my client secret, client id, and
                             ; transport type; if you plan to use smudge check out
                             ; the github link above for official instructions
(map! :desc "Spotify Mode" "M-s m" 'global-smudge-remote-mode)
(map! :map smudge-mode-map
      (:prefix "M-s"
      :desc "Play/Pause" "SPC" 'smudge-controller-toggle-play
      :desc "Search Track" "t" 'smudge-track-search
      :desc "Next Track" "n" 'smudge-controller-next-track
      :desc "Previous Track" "p" 'smudge-controller-previous-track
      :desc "Recently Played" "l" 'smudge-recently-played
      :desc "Shuffle" "s" 'smudge-controller-toggle-shuffle
      :desc "Repeat" "r" 'smudge-controller-toggle-repeat
      :desc "Device" "d" 'smudge-select-device
      )
)
(setq! smudge-player-status-format "[%t - %a]{%s%r}")

;; Org Pandoc Import Config
;; https://github.com/tecosaur/org-pandoc-import
(use-package! org-pandoc-import :after org)
(org-pandoc-import-transient-mode t)

;; ispell setup
;; using flyspell now
(setq ispell-dictionary "en")
(setq ispell-personal-dictionary "~/.doom.d/en.pws")
;; (add-hook! 'spell-fu-mode-hook
;;            (spell-fu-dictionary-add (spell-fu-get-personal-dictionary "personal" "~/.doom.d/en.pws")))

;; org config
(setq org-format-latex-options ;; makes latex smaller
  '(:foreground default :background default :scale 1
		:html-foreground "Black" :html-background "Transparent"
		:html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
(setq org-list-demote-modify-bullet
      '(("-" . "+")("+" . "-")("1." . "+")))

;; org roam config
(setq org-roam-db-node-include-function
      (lambda ()
        (not (member "ATTACH" (org-get-tags)))))


;; anki-editor config to merge with org mode
(add-hook! 'org-mode-hook #'anki-editor-mode)
(map! :map org-mode-map
      :localleader :desc "push to Anki" :n "R" #'anki-editor-push-notes
      :localleader :n "z" #'anki-editor-insert-note)

;; cc mode config
(setq! +format-on-save-enabled-modes '(not c++-mode))

;; cc debug config
(setq dap-auto-configure-mode t)
(require 'dap-cpptools)
(fset 'dap-quit
   (kmacro-lambda-form [?  ?w ?j escape ?  ?b ?k ?y ?y ?  ?w ?j ?  ?b ?k ?  ?w ?q] 0 "%d"))
(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug
      :desc "dap quit"          "q" #'dap-quit

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)
(dap-register-debug-template ;; until I figure out something better
  "OpenGL Engine"
  (list :type "cppdbg"
        :request "launch"
        :name "cpptools::Run Configuration"
        :MIMode "gdb"
        :program "/home/andys/Developement/OpenGl-Engine/build/engine"
        :cwd "/home/andys/Developement/OpenGl-Engine"))
