        program inserthorizon    
        character filetop*80,filebot*80

        open(10,file='vfile.a1')

	print*, 'insert the filename of the layer bottom'
        read(*,'(a80)') filebot

        open(20,file=filebot)
        open(30,file='vfile.dat')

	print*, 'vfile parameters:'
	print*, 'insert fz,nz,dz'
        read(*,*) fz,nz,dz
	print*, 'insert nx'
	read(*,*) nx
        
	print*, ' '  
	 
        print*, 'velocity of the new layer?'
        read*, vel
         
        do i=1,nx
        read(20,*)x,z
          do j=1,nz
          read(10,*)v
          zv=fz+j*dz
          if (zv.gt.z)v=vel
          write(30,*)v
          end do 

        end do
       
	close(20)
	close(10)
	close(30)
 
        stop
        end       
