        program updatevelocitygrid
        implicit real (a-g,p-z)
        character file1*30,file2*30

        open(13,file='tmp')
        read(13,*) nz,dz,fz0,nx,dx,fx0
        close(13)
        
        open(10,file='vfile.a')
        open(11,file='vfile.a1')

        open(12,file='corr')
        read(12,*) ncdp,depth
        print*, 
     $'...i working on cdp number',ncdp,' at the depth of ',depth
        close(12)

        open(14,file='deltap.txt')
        read(14,*) xlambda
        close(14)
c       print*, 'dimmi lambda'
c       read*, xlambda

       open(70,file='input_oriz')                     
       read(70,'(a30)') file1
       read(70,'(a30)') file2
       close(70)

       open(21,file=file1)
       open(22,file=file2)

        read(21,*) x1,z1
 10     read(21,*,end=98) x,z
        if(x1.le.ncdp.and.x.gt.ncdp) then
         ztop=(z-z1)/(x-x1)*(ncdp-x1)+z1
         goto 11
        else
         goto 10
        endif
 11     close(21)

        read(22,*) x1,z1
 12     read(22,*,end=98) x,z
        if(x1.le.ncdp.and.x.gt.ncdp) then
         zbot=(z-z1)/(x-x1)*(ncdp-x1)+z1
         goto 13
        else
         goto 12
        endif
 13     close(22)
       
c        if((ztop-depth).gt.50..or.(depth-zbot).gt.50.) then
c         print*,  
c     $'look at the picking: z-top, z-bottom and depth:',ztop,zbot,depth 
c         print*, 'if you agree, write 1'
c         read*, nopt
c         if(nopt.ne.1) stop
c        endif

        open(30,file='vfile.corr')
        open(31,file='vfile.corr1')
        open(32,file='vfile_a.corr')
        open(33,file='vfile_a.corr1')
        
        do i=1,nx
         x=fx0+(i-1)*dx
         read(32,*) xcorr,correzzione
         if(xcorr.eq.ncdp) then
          write(33,*) xcorr,xlambda
         else
          write(33,*) xcorr,correzzione
         endif
         do j=1,nz
          z=fz0+(j-1)*dz
          read(10,*,end=99) vel
          read(30,*) zcorrez
          if(x.eq.ncdp.and.(z.le.zbot.and.z.gt.ztop)) then
           vel=vel+xlambda
           write(11,*) vel
           write(31,*) vel 
c  xlambda
          else
           write(11,*) vel
           write(31,*) zcorrez
          endif
         enddo
        enddo

 99     close(11)
        close(10)
        close(30)
        close(32)
        close(33)
        close(31)
        
        stop

 98     print*, 'ATTENTION: the point has not been found!'

        stop
        end
