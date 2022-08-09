        program vel2layer
        dimension zhor(10000,20),v(10000,10000),jhor(20)
        dimension nop(20),vm(20)

        open(10,file='nref.txt')
        read(10,*) nref
        if(nref.gt.20) then
         print*, 'Change zhor!'
         stop
        endif
        close(10)

        open(14,file='horizon_tot.dat')
        open(12,file='vfile.a1')

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

        if(nx.gt.10000) then
         print*, 'Change zhor and v'
        endif

        do j=1,nref
         do i=1,nx
          read(14,*) x,zhor(i,j)
         enddo
        enddo
        close(14)

        do i=1,nx

         do k=1,nref
          vm(k)=0
          jhor(k)=0
          nop(k)=0
         enddo

         do j=1,nz
          z=fz+dz*(j-1)
          
          read(12,*) vel

          do k=1,nref

           if(z.le.zhor(i,k).and.k.eq.1) then
            vm(k)=vm(k)+vel
            nop(k)=nop(k)+1
            jhor(k)=j            
            goto 20
           endif

           if(z.gt.zhor(i,k).and.k.ne.nref.and.
     $      z.le.zhor(i,k+1)) then
            vm(k+1)=vm(k+1)+vel
            nop(k+1)=nop(k+1)+1
            jhor(k+1)=j
            goto 20
           endif

           if(k.eq.nref) then
            vm(k+1)=vm(k+1)+vel
            nop(k+1)=nop(k+1)+1
            jhor(k+1)=j
            goto 20
           endif

          enddo

 20      enddo

          do k=1,jhor(1)
           v(i,k)=vm(1)/nop(1)
          enddo

          do k=jhor(nref)+1,nz
           v(i,k)=vm(nref+1)/nop(nref+1)
          enddo
 
          do k=1,nref-1
           do j=jhor(k)+1,jhor(k+1)
            v(i,j)=vm(k+1)/nop(k+1)
           enddo
          enddo        

        enddo

        close(12)
        close(14)
                
        open(16,file='vfile_layer.dat')
        do i=1,nx
         do j=1,nz
          write(16,*) v(i,j)
         enddo
        enddo
        close(16)

        stop
        end

