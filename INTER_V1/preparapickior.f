        program preparapick
        real layer
        dimension layer(5000,2),p(1000,2),pn(5000)
        character*4 cip
        character*80 file1
       
        cip='cip='
       
        open(10,file='mpick.dat')

        i=1
 10     read(10,*,end=99) p(i,2),p(i,1)
        i=i+1
        goto 10
 99     n=i-1
        close(10)
      
        print*, 'cdp min max e passo'
        read*, cdp1,cdp2,pcdp

        ncdp=(cdp2-cdp1)/pcdp+1

        do i=1,ncdp
         cdp=cdp1+(i-1)*pcdp
         if(cdp.le.p(1,1)) then
          pn(i)=p(1,2)
          goto 20
         endif
         if(cdp.ge.p(n,1)) then
          pn(i)=p(n,2)
          goto 20
         endif
         do j=1,n-1
          if(cdp.ge.p(j,1).and.cdp.le.p(j+1,1)) then
           x=(p(j+1,2)-p(j,2))/(p(j+1,1)-p(j,1))
           pn(i)=x*(cdp-p(j,1))+p(j,2)
           goto 20
          endif
         enddo
         print*, 'errore',cdp
 20     enddo    

        print*, 'dimmi il file layer'
        read(*,'(a80)') file1

        open(30,file=file1)
        i=1
 30     read(30,*,end=98) layer(i,1),layer(i,2)
        i=i+1
        goto 30
 98     close(30)
        nd=i-1
         
        open(20,file='pick_or.dat')
        open(31,file='mpicks_or.dat')

         do i=1,ncdp
          cdp=cdp1+(i-1)*pcdp
          nnn=int(cdp)
          do j=1,nd
           if(nnn.eq.int(layer(j,1))) then
            z=layer(j,2)
            goto 40
           endif
          enddo
          print*, 'errore depth',nnn
 40        write(20,'(a4,i5,f8.2,f11.7)') cip,nnn,z,pn(i)
           write(31,'(a4,i5,f8.2,f11.7)') cip,nnn,z,pn(i)
         enddo

         close(20)
         close(31)

         stop
         end
