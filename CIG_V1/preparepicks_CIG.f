        program preparepicks
        dimension p(10000,2),pn(10000)

       
        open(10,file='picks.dat')
        open(11,file='horizon.dat')

        i=1
 10     read(10,*,end=99) p(i,2),p(i,1)
        i=i+1
        goto 10
 99     n=i-1
        close(10)
      
        print*, 'insert x initial (fx), x final and dx'
        print*, '(in agreement with the vfile parameters)'
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
         print*, 'error',cdp

 20      write(11,*) cdp,pn(i)     
        enddo    

         close(10)
         close(11)

         stop
         end
