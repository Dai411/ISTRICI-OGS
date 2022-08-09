        program interpolagriglia_new
        implicit real (a-g,p-z)
        dimension nindice(5000,2),xmatvet(5000,2),diff(5000)
        dimension vg1(5000,5000)
        dimension zbot1(5000),ztop(5000),zbot(5000),vg(5000,5000)
        character file1*30,file2*30,file3*30,file4*30

        do i=1,5000
         do j=1,2
          nindice(i,j)=0
         enddo
        enddo
        
        open(13,file='tmp')
        read(13,*) nz,dz,fz0,nx,dx,fx0
        close(13)
       
        if(nx.gt.5000) then
         print*, 'cambia grandezza matrice'
         stop
        endif
       
        open(10,file='vfile.aold')
        open(11,file='vfile.a1')
        open(77,file='vfile_diff.dat')

       open(70,file='input_oriz')                     
       read(70,'(a30)') file1
       read(70,'(a30)') file2
       close(70)

        open(32,file='vfile_a.corr')
        do i=1,nx
         read(32,*) x1,x2
         xmatvet(i,1)=x1
         xmatvet(i,2)=x2
        enddo
        close(32)

        if(xmatvet(1,2).eq.0.) then
         do i=2,nx
          if(xmatvet(i,2).ne.0.0) then
           do j=1,i-1
            xmatvet(j,2)=xmatvet(i,2)
           enddo
           goto 102
          endif
         enddo
        endif
 102    nin=i
        if(xmatvet(1,2).ne.0.0) nin=1
        if(xmatvet(nx,2).eq.0.) then
         do i=nx,1,-1
          if(xmatvet(i,2).ne.0.0) then
           do j=nx,i,-1
            xmatvet(j,2)=xmatvet(i,2)
           enddo
           goto 103
          endif
         enddo
        endif
 103    nfi=i
        if(xmatvet(nx,2).ne.0.0) nfi=nx

        x1=xmatvet(nin,1)
        y1=xmatvet(nin,2)
        x2=0.
        y2=0.
        do i=nin+1,nfi-1
         if(xmatvet(i,2).eq.0.) then
          if(x2.eq.0.0.and.y2.eq.0.0) then
           ncontrol=0
          do j=i+1,nfi
           if(xmatvet(j,2).ne.0.0.and.ncontrol.eq.0) then
            x2=xmatvet(j,1)
            y2=xmatvet(j,2)
             ncontrol=1
c            goto 104
             xmatvet(i,2)=(y2-y1)/(x2-x1)*(xmatvet(i,1)-x1)+y1
           endif
          enddo
         else
 104      xmatvet(i,2)=(y2-y1)/(x2-x1)*(xmatvet(i,1)-x1)+y1
         endif
         else
          x1=xmatvet(i,1)
          y1=xmatvet(i,2)
          x2=0.
          y2=0.
         endif
        enddo

       open(21,file=file1)
       open(22,file=file2)
        do i=1,nx
         read(21,*) x,ztop(i)
         read(22,*) x,zbot(i)
         zbot1(i)=zbot(i)
        enddo
        close(21)
        close(22)

        open(55,file='oriznew')
        
        do i=1,nx
         x=fx0+(i-1)*dx

         iopt=0
         velmed=0.0
         ncont=0
         do j=1,nz
          z=fz0+(j-1)*dz
          read(10,*) vel
          vg1(i,j)=vel
          vel2=vel
c
c          xmatvet(i,2)=vel2
c
          if(iopt.eq.0) then
           if(z.gt.ztop(i)) then
            iopt=1
            zbot1(i)=zbot(i)*(vel+xmatvet(i,2))/vel2
            write(79,*)
     $    i,j,x,z,vel,xmatvet(i,2),zbot(i),zbot1(i),ztop(i)
            if(ztop(i).gt.zbot1(i)) print*, 'attenzione a ztop!',x
c            zbot1(i)=ztop(i)-dz
           endif
          endif
          if(z.lt.zbot(i).and.z.ge.ztop(i)) then
           velmed=velmed+(vel+xmatvet(i,2))
           ncont=ncont+1
          endif
          if(z.le.zbot1(i).and.z.ge.ztop(i)) then
           vel=vel+xmatvet(i,2)
           vel1=vel
           write(78,*) x,z,i,j,vel2,vel,xmatvet(i,2)
           nindice(i,1)=j
          endif
          vg(i,j)=vel
         enddo
         nnn=int(ztop(i)/dz)+1
c         print*, i,nnn,nindice(i,1),velmed/(ncont*1.)
         do j=nnn,nindice(i,1)
          vg(i,j)=velmed/(ncont*1.)
         enddo
         if(nindice(i,1).ne.0) then
         do j=nindice(i,1)+1,nz
c
c se vuoi cambiare la velocita' dell'ultimo strato cambia qui
c
          vg(i,j)=vg(i,nindice(i,1)) !2000.             
         enddo
         endif
         write(55,*) xmatvet(i,1),zbot1(i),zbot(i),vel1,vel2
         diff(i)=zbot1(i)-zbot(i)
         nindice(i,2)=diff(i)/dz
        enddo
        close(10)
        close(55)
       
 10     print*, 'devo aggiornare orizzonti? (si=1)'
        read*, nopt
        if(nopt.ne.1) goto 79

        print*, 'dimmi il nome del file dell''orizzonte'
        read(*,'(a30)') file3
        print*, 'dimmi il nome del nuovo file'
        read(*,'(a30)') file4

        open(30,file=file3)
        open(31,file=file4)
        do i=1,nx
         read(30,*) x,y
         y1=y+diff(i)
         write(31,*) x,y1
        enddo
        close(30)
        close(31)

c        goto 10   

c 79     do i=1,nx
c         do j=nindice(i,1)+1,nz
c          k=j-nindice(i,2)
c          if(k.gt.nz) k=nz
c          if(k.lt.1) nz=1
c          vg(i,j)=vg1(i,k)
c          write(73,*) i,j,k,vg(i,j),vg1(i,k)
c         enddo
c         enddo

 79       do i=1,nx
         x=fx0+dx*(i-1)
         do j=1,nz
          z=dz*(j-1)
c         if(j.gt.nindice(i,1).and.nindice(i,1).ne.0) vg(i,j)=1500.
          write(11,*) vg(i,j)
          write(77,*) vg(i,j)-vg1(i,j)
c          if(vg(i,j).gt.2000) print*, i,j,vg(i,j)
          enddo
        enddo
        close(11)
        close(77)
       
        stop
        end
        
