        program inseriscigradiente
		
	print*, 'insert the vfile parameters: nz and nx'
        read*, nz,nx
        
        print*, 
     $ 'insert the constant velocity of the bottom layer (m/s)'
        read*, vmax

        print*, 
     $ 'insert the initial velocity (m/s) and velocity gradient' 
        print*, '(1/s) to be inserted in the bottom layer'
        read*, v1,dv

        open(10,file='vfile.a1')
        open(11,file='vfile.dat')
        
        do i=1,nx
         io=0
         do j=1,nz
          read(10,*) v
          if(v.ne.vmax) then
            write(11,*) v
          else
           if(io.eq.0) then
            io=1
            j0=j
           endif
           v=v1+dv*(j-j0)
            write(11,*) v
          endif
         enddo
        enddo

        close(10)
        close(11)

        stop
        end
