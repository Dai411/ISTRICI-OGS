        program inseriscigradiente

        open(10,file='v.par')
        read(10,*) nz
        read(10,*) dz
        read(10,*) fz
        read(10,*) nx
        read(10,*) dx  
        read(10,*) fx   
        read(10,*) ncdpmin
        read(10,*) ncdpmax
        read(10,*) ncdp
        close(10)

c	print*, 'insert the vfile parameters: nz and nx'
c        read*, nz,nx
        
c        print*, 
c     $ 'insert the constant velocity of the bottom layer (m/s)'
c        read*, vmax

        print*, 
c     $ 'insert the initial velocity (m/s) and velocity gradient' 
     $ 'insert the velocity gradient (1/s) of the bottom layer'
c        read*, v1,dv
        read*, dv

        open(10,file='vfile.a1')
        open(11,file='vfile.dat')
        open(12,file='horizon.dat')
        
        do i=1,nx
c         io=0
         read(12,*) x,zmax
         do j=1,nz
          z=fz+(j-1)*dz
          read(10,*) v
          if(z.le.zmax) then
            write(11,*) v
            v1=v
          else
c           if(io.eq.0) then
c            io=1
c            j0=j
c           endif
           v=v1+dv*(z-zmax)
            write(11,*) v
          endif
         enddo
        enddo

        close(10)
        close(11)

        stop
        end
