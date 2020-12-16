(def mask {})
(def mem {})
(def smem {})

(defn char-index-map  [^String s] (group-by #(.charAt s (- (count s) % 1)) (range (count s))))
(defn exp [x n] (reduce * (repeat n x)))
(defn getbit [n x] (bit-test n x))
(defn setbit [b n] (reduce(fn [out [k p]] (if(getbit n k) (bit-set out p) (bit-clear out p))) b (map-indexed vector (mask \X))))

(doseq [ln (line-seq (java.io.BufferedReader. *in*))]
	(def in (re-matches #"(\w+)(?:\[(\d+)\])? \= (.+)" ln))
	(if(=(nth in 1) "mask")
		(do
			(def mask (char-index-map (nth in 3)))
			(def xs (count (mask \X)))
		)
		(do
			(def addr (Integer/parseInt (nth in 2)))
			(def nr (Integer/parseInt (nth in 3)))

			(def oneset (reduce (fn [acc p] (bit-set acc p)) addr (mask \1)))

			(doseq [i (range (exp 2 xs))] (def smem (assoc smem (setbit oneset i) nr)))

			(def mem (assoc mem addr (reduce (fn [acc [k v]] (reduce (fn [acc p] (if(= k \1) (bit-set acc p) (bit-clear acc p) )) acc v)) nr mask)))
		)
	)
)

(println "Part 1 sum:" (reduce + (vals mem)))
(println "Part 2 sum:" (reduce + (vals smem)))
