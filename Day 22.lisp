


(defvar player1 nil)
(defvar player2 nil)
(defvar _DEBUG nil)

(defun countscore (cards)
    (let ((sum 0)) (loop
        (incf sum (* (length cards) (pop cards)))
        (when (eq cards nil) (return sum))
    ))
)


(defun playgame (p1 p2 nr part)
    (when _DEBUG (princ "--- Start of Game ")(write nr)(princ " ---")(terpri)(terpri))
    (let (
        (turn 0)
        (history1 nil)
        (history2 nil)
        (card1 0)
        (card2 0)
    )
    (loop
        (incf turn 1)
        (when _DEBUG (princ " -[Round ")(write turn)(princ " of Game ")(write nr)(princ "]-")(terpri))
        (when (= part 2)
            (when (or (find p1 history1 :test #'equal) (find p2 history2 :test #'equal)) 
                (when _DEBUG (princ "  Loop detected!")(terpri)(terpri))
                (return (list 1 p1))
            )
            (push p1 history1)(push p2 history2)
        )
        (setq p1 (reverse p1))
        (setq p2 (reverse p2))
        (when _DEBUG (princ "  Player 1: ")(write p1)(terpri)(princ "  Player 2: ")(write p2)(terpri))
        (setq card1 (pop p1))
        (setq card2 (pop p2))
        (setq p1 (reverse p1))
        (setq p2 (reverse p2))
        (when _DEBUG (princ "  Player 1 plays: ")(write card1)(terpri)(princ "  Player 2 plays: ")(write card2)(terpri))
        (if (and (= part 2) (>= (length p1) card1) (>= (length p2) card2))
            (progn 
                (when _DEBUG (terpri))
                (if (= 1 (car (playgame p1 p2 (+ nr 1) part)))
                    (progn (push card1 p1)(push card2 p1)
                        (when _DEBUG (princ "---- End of Subgame ----")(terpri)(terpri)(princ " Player 1 wins round ")(write turn)(princ " of game ")(write nr)(terpri))
                    )
                    (progn (push card2 p2)(push card1 p2)
                        (when _DEBUG (princ "---- End of Subgame ----")(terpri)(terpri)(princ " Player 2 wins round ")(write turn)(princ " of game ")(write nr)(terpri))
                    )
                )
                
            )
            (if (> card1 card2)
                (progn (push card1 p1)(push card2 p1)
                    (when _DEBUG (princ " Player 1 wins round ")(write turn)(princ " of game ")(write nr)(terpri))
                )
                (progn (push card2 p2)(push card1 p2)
                    (when _DEBUG (princ " Player 2 wins round ")(write turn)(princ " of game ")(write nr)(terpri))
                )
            )
        )
        (when _DEBUG (terpri))
        (if (eq p1 nil) (return (list 2 p2)))
        (if (eq p2 nil) (return (list 1 p1)))
    )
    )
)

(defvar card nil)
(read-line nil nil nil)
(loop
    (setq card (read nil nil nil))
    (when (eq card 'player) (return))
    (push card player1)
)
(read-line nil nil nil)
(loop
    (setq card (read nil nil nil))
    (when (eq card nil) (return))
    (push card player2)
)

(defvar winnerPart1 nil)
(defvar winnerPart2 nil)
(if t
(if _DEBUG 
    (progn 
        (setq winnerPart1 (playgame player1 player2 1 1))
        (princ "--- We have a winner! ---")(terpri)
        (princ "Winner: ")(write (car winnerPart1))(terpri)
        (princ "Winner's Cards: ")(write (reverse (cadr winnerPart1)))(terpri)
        (princ "Winner's score: ")(write (countscore (reverse (cadr winnerPart1))))(terpri)(terpri)
        (setq winnerPart2 (playgame player1 player2 1 2))
        (princ "--- We have a winner! ---")(terpri)
        (princ "Winner: ")(write (car winnerPart2))(terpri)
        (princ "Winner's Cards: ")(write (reverse (cadr winnerPart2)))(terpri)
        (princ "Winner's score: ")(write (countscore (reverse (cadr winnerPart2))))(terpri)(terpri)
    )
    (progn
        ;(princ "Answer Part1: ")(write (countscore (reverse (cadr (playgame player1 player2 1 1)))))(terpri)
        (princ "Answer Part2: ")(write (countscore (reverse (cadr (playgame player1 player2 1 2)))))(terpri)(terpri)
    )
)
)

;10601 too low.