        program createvfile

        print*, 'give me nx and nz'
        read*, nx,nz

        print*, 'give me initial velocity'
        read*, vel

        open(10,file='vfile.dat')
        do i=1,nx
         do z=1,nz
          write(10,*) vel
         enddo
        enddo

        close(10)

        stop
        end
