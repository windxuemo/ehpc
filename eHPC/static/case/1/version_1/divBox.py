import random
class Box(object):
    def __init__(self , I ,J , K ,PA=[0.0 ,0.0 ,0.0] ,PB=[0.0,0.0,0.0] ):
        self.I , self.J , self.K = I , J , K
        self.IJK = [ self.I , self.J , self.K  ]
        self.PA , self.PB = PA , PB
    def getM(self):
        return self.I * self.J * self.K
    def cuttest(self , guideSize , tor=1.5):
        ''' try to return a list of Box which gernate by guideSize  '''
        #print  "Try to cut : ",  self.I , self.J , self.K 
        divnum = float( self.getM() ) / guideSize
        if divnum < tor :
            return [ self ]
        else :
            # get the biggest dim and cut it 
            sorteddim = [ 0 , 1]  if self.I > self.J else [ 1 ,0 ] 
            sorteddim = sorteddim + [ 2 ]  if self.IJK[ sorteddim[0] ] > self.K else [2] + sorteddim
            #print sorteddim
            cellsize =  self.IJK[ sorteddim[1 ] ] *  self.IJK[ sorteddim[2] ] 
            divnumint = int( divnum )
            guidecut = self.IJK[ sorteddim[ 0 ] ] / divnumint 
            tail = self.IJK[ sorteddim[ 0 ] ] -  guidecut * divnumint 
            # print divnumint , guidecut , tail 
            listA , listB = self.IJK[:] , self.IJK[:]
            if divnum  < 2  or guidecut < self.IJK[ sorteddim[ 1 ] ] or guidecut < self.IJK[ sorteddim[ 2 ] ]  :
                ''' It is like a cubic , and cannot cut one div  '''
                listA[ sorteddim[ 0 ] ] = listA[ sorteddim[ 0 ] ] / 2 
            else : 
               guidecut = guidecut if tail == 0 else guidecut +1 
               listA[ sorteddim[ 0 ] ] = guidecut 
            listB[ sorteddim[ 0 ] ] =  self.IJK [ sorteddim[ 0 ] ] - listA[ sorteddim[ 0 ] ]
            PC , PD =  self.PA[:] , self.PB[:]
            value_0 , value_1 = self.PA[sorteddim[ 0 ] ] , self.PB[ sorteddim[ 0 ]  ]
            value_tmp = value_0 + ( value_1 - value_0 ) * float (listA[ sorteddim[ 0 ] ] )/ self.IJK [ sorteddim[ 0 ] ] 
            PC[ sorteddim[ 0 ]  ] = value_tmp 
            PD[ sorteddim[ 0 ]  ] = value_tmp
            boxA , boxB = Box ( *listA , PA=self.PA[:] ,PB=PD[:] ) , Box ( *listB, PA=PC[:] ,PB=self.PB[:] )
            return boxA.cuttest( guideSize ) + boxB.cuttest( guideSize ) 
'''
rint=random.randint
listnum = 3
Ilist , Jlist , Klist , Mlist = [0] * 20 , [0] * 20 , [0] *20 , [0] * 20 
boxList = [] 
for i in range(listnum) :
    Itmp , Jtmp , Ktmp = rint(1,50 ) , rint(1,50) , rint(1,50)
    boxtmp = Box( rint(1,50 ) , rint(1,50) , rint(1,50) , [0.0 ,0.0 ,0.0] ,[ 10.0 , 10.0 , 10.0 ])
    print "org : " , boxtmp.IJK
    print "after cut : "
    cutboxlist = boxtmp.cuttest( 1000 )
    for eachbox in cutboxlist :
        print eachbox.IJK , eachbox.PA,  eachbox.PB
#print box1.getM()
'''
