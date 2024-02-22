(clear-all)

(define-model choice-solution

(sgp :v nil :ul t  :egs 3 :esc t)
(chunk-type goal state)
(chunk-type response val)

;;one semi-colon breaks colors
(add-dm
 (start isa chunk)
 (attending-choose isa chunk) (respond isa chunk)
 (attending-feedback isa chunk) (read-feedback isa chunk) (done isa chunk)
 (goal isa goal state start)
)

(install-device '("motor" "keyboard"))

(P start
    =goal>
       isa     goal
       state   start
==>
    =goal>
        isa goal
        state attending-choose
    +visual-location>
)

(P attend-letter
   =goal>
      ISA         goal
      state       attending-choose
   =visual-location>
   ?visual>
      state       free
==>
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
   =goal>
      ISA         goal
      state       respond
)

(p respond-t
    =goal>
      isa      goal
      state    respond
    =visual>
      isa      visual-object
      value    "choose"
      ;;(!print! =val) 
    ?manual>
      state    free   
    ?imaginal>
      state    free
   ==>
    +manual>
        cmd press-key
        key "t"
    +imaginal>
        isa     response
        val     "tails"
    =goal>
      isa      goal
      state    attending-feedback
    +visual-location>
)



(p respond-h
    =goal>
      isa      goal
      state    respond
    =visual>
      isa      visual-object
      value    "choose"
      ;;(!print! =val)
    ?manual>
      state    free   
    ?imaginal>
      state    free
   ==>
    +manual>
        cmd press-key
        key "h"
    +imaginal>
        isa     response
        val     "heads"
    =goal>
      isa      goal
      state    attending-feedback
    +visual-location>
)


(p attending-feedback
    =visual-location>
    =goal>
      isa      goal
      state    attending-feedback
 ==>
    =goal>
      isa      goal
      state    read-feedback
    +visual-location>
      :attended nil
)



(p read-feedback
   =goal>
       ISA goal
       state read-feedback
   =visual-location>
   ?visual>
      state       free
==>
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
   =goal>
       ISA        goal
       state      done

)

(p done-correct
    =goal>
      isa      goal
      state    done
    =visual>
      isa      visual-object
      value    =val
    =imaginal>
      val  =val
   ==>
    =goal>
      state    start
)

(p done-wrong
    =goal>
      isa      goal
      state    done
    =visual>
      isa      visual-object
      value    =val
    =imaginal>
      -  val  =val
   ==>
    =goal>
      state    start
)

(goal-focus goal)

;;(spp respond-h :u 10)
;;(spp respond-t :u 10)

;;the :u value from spp indicates last utility value and noise

(spp attend-letter :reward 0)
(spp done-correct :reward 10)
;;rewards

)
