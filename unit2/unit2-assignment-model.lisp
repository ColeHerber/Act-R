(clear-all)

  (define-model unit2

  (sgp :v nil :show-focus nil)

  ;;sorry this is so late. I really had no clue how to do this until working on it for way too long
  ;;future notes for me, in = in command(goal, imaginal yadda) checks and assigns temproary "variable"
  ;;isa initializes
  ;;+ adds new task to that buffer, usually visual
  ;;? asks question directly to that buffer
  ;;chunks initialize into each module individually.
  ;;
  (chunk-type read-letters state)
  (chunk-type array letter1 letter2 letter3 choice)

  (add-dm
   (start isa chunk)
   (attend isa chunk)
   (respond isa chunk)
   (find-next isa chunk)
   (choose isa chunk)
   (done isa chunk)
   (goal isa read-letters state start))


  (P find-unattended-letter
     =goal>
        ISA         read-letters
        state       start
     ?imaginal>
     	  state       free
   ==>
     +visual-location>
        :attended    nil
     =goal>
        state       find-location
     +imaginal>
     	  isa         array
     	  letter1     nil
     	  letter2     nil
     	  letter3     nil
  )


  (P find-next-letter
     =goal>
        ISA         read-letters
        state       find-next
   ==>
     +visual-location>
        :attended    nil
     =goal>
        state       find-location
  )


  (P attend-letter
     =goal>
        ISA         read-letters
        state       find-location
     =visual-location>
     ?visual>
        state       free
  ==>
     +visual>
        cmd         move-attention
        screen-pos  =visual-location
     =goal>
        state       attend
  )

  (P encode-letter-first
     =goal>
        ISA         read-letters
        state       attend
     =visual>
        value       =letter
     ?imaginal>
        state       free
     =imaginal>
        isa         array
        letter1     nil
        letter2     nil
        letter3     nil
  ==>
     =goal>
        state       find-next
     +imaginal>
        isa         array
        letter1      =letter
        letter2     nil
        letter3     nil
  )


  (P encode-letter-second
     =goal>
        ISA         read-letters
        state       attend
     =visual>
        value       =letter
     ?imaginal>
        state       free
     =imaginal>
        isa         array
     	  letter1     =letter1
     	  letter2     nil
     	  letter3     nil
  ==>
     =goal>
        state       find-next
     +imaginal>
        isa         array
        letter1      =letter1
        letter2      =letter
        letter3      nil
  )

  (P encode-letter-third
     =goal>
        ISA         read-letters
        state       attend
     =visual>
        value       =letter
     ?imaginal>
        state       free
     =imaginal>
     	  isa         array
     	  letter1     =letter1
     	  letter2     =letter2
     	  letter3     nil
  ==>
  	=goal>
  		state     choose
      +imaginal>
      	isa       array
      	letter1   =letter1
      	letter2   =letter2
      	letter3   =letter
  )

  (P choose-letter-3
  	=goal>
  		isa       read-letters
  		state     choose
  	?imaginal>
  		state     free
  	=imaginal>
  		isa       array
  		letter1   =letter1
  		letter2   =letter1
  		letter3   =letter
  ==>
  	=goal>
  		state     respond
  	+imaginal>
  		isa       array
  		choice  =letter
  )

  (P choose-letter-2
  	=goal>
  		isa       read-letters
  		state     choose
  	?imaginal>
  		state     free
  	=imaginal>
  		isa       array
  		letter1   =letter1
  		letter2   =letter
  		letter3   =letter1
  ==>
  	=goal>
  		state     respond
  	+imaginal>
  		isa       array
  		choice  =letter
  )

  (P choose-letter-1
  	=goal>
  		isa       read-letters
  		state     choose
  	?imaginal>
  		state     free
  	=imaginal>
  		isa       array
  		letter1   =letter
  		letter2   =letter1
  		letter3   =letter1
  ==>
  	=goal>
  		state     respond
  	+imaginal>
  		isa       array
  		choice  =letter
  )

  (P choose-letter-0
  	=goal>
  		isa       read-letters
  		state     choose
  	?imaginal>
  		state     free
  	=imaginal>
  		isa       array
  		letter1   =letter
      letter2   =letterT
      - letter2 =letter
      - letter1 =letterT
      - letter3 =letter
      - letter3 =letterT
      

  ==>
  	=goal>
  		state     respond
  	+imaginal>
  		isa       array
  		choice  =letter
  )



  (P respond
     =goal>
        ISA         read-letters
        state       respond
     =imaginal>
        isa         array
        choice    =letter
     ?manual>   
        state       free
  ==>
     =goal>
        state       done
     +manual>
        cmd         press-key
        key         =letter
  )

  (goal-focus goal)
  )