#!/bin/env python
import sys
import divBox
class setting (object):
    ''' this class for tool use settings '''
    myVersion = "0.0"
    DEBUG = False
    file_in = sys.argv[1] #"L1_floor.fds"
    file_out = "out.fds"
print setting.file_in
DEBUG = setting.DEBUG
class Record(object):
    ''' this class is one record info '''
    myVersion = "0.0"
    Type = ''
    Text = '' 
    Name = ''
    keys = []
    values = []
    def append(self , object):
        self.Text = self.Text + object
    def Copy(self ):
        newRecord = Record()
        newRecord.Type , newRecord.Text , newRecord.Name  = self.Type , self.Text, self.Name
        newRecord.keys = self.keys[:]
        newRecord.values = self.values[:]
        return newRecord
    def debugprint(self):
        if DEBUG:
            print self.Type ,    self.Text , self.Name , self.keys ,self.values
    def setValue( self , key , newvalue ):
        vindex = self.keys.index( key )
        self.values[vindex ] = newvalue
    def getValue (self , key) :
        vindex = self.keys.index( key )
        return self.values[vindex ] 
    def refreshText(self):
        if self.Type == "RECORD":
            newText = '&' + self.Name + ' '
            for itemI in range( len(self.keys) ):
                newText = newText + self.keys[itemI] + '=' + self.values[itemI]
                if itemI == len(self.keys) - 1 :
                    newText = newText + ' /'
                else : 
                    newText = newText + ' , '
        self.Text = newText
class fdsdoc(object):
    ''' this class recode the information of the fds file '''
    myVersion = "0.0"
    


filein = open(setting.file_in)
# read the file
recordNotEnd = False 
state_now = "unknow"
record = Record()
recordList=[]
for eachLine in filein:
    #print eachLine
    if recordNotEnd :
        # record and test if is end 
        record.append( eachLine )
        if eachLine.find('/') != -1:
            recordNotEnd = False
            #print "RECORD  A:::::::::::" , record.Type , record.Text
            recordList.append(record)
            record = Record()
        else :
            pass #print "RECORD NOT END " , recordNotEnd
    else :
        # new record , test if is comm
        if not eachLine.startswith('&'):  # isComm = test()
        #if isComm :
            record.append( eachLine )# record comm 
            record.Type = 'COMM'
            #print "COMM:::::::::::" , record.Type , record.Text
            recordList.append(record)
            record = Record()
        else : # is a record
            record.Type = "RECORD"
            record.append (eachLine)
            # test if  Record end 
            if eachLine.find('/') != -1 : #recordEnd = test ()
            #if recordEnd :
                recordNotEnd = False
                #print "RECORD  B :::::::::::" , record.Type , record.Text
                recordList.append(record)
                record = Record() # record this record , and the whole 
            else : # record not end
                recordNotEnd = True 
                #print "RECORD NOT END " , recordNotEnd
ucRecordList = []
for eachRecord in recordList :
    if eachRecord.Type == 'RECORD':
        ucRecordList.append( eachRecord )
        ucRecordList[-1].keys = []
        ucRecordList[-1].values = []
        eachRecord.Name , spstr , string_post = eachRecord.Text.partition(' ')
        eachRecord.Name=eachRecord.Name[1:]
        string_post , spstr , string_comm = string_post.partition('/')
        string_list = string_post.split(', ') # must be ', ' not ',' !
        for eachString in string_list:
            tmp_key , spstr , tmp_value = eachString.partition('=')
            ucRecordList[-1].keys.append(tmp_key.strip())
            ucRecordList[-1].values.append(tmp_value.strip()) 
        
meshRecordList = []
MeshList = []
for eachRecord in ucRecordList :
    if eachRecord.Name == "MESH":
        meshRecordList.append(eachRecord)
        id_IJK = eachRecord.keys.index("IJK")
        id_XB = eachRecord.keys.index("XB")
        IJK_str =  eachRecord.values[ id_IJK ].split(',')
        XB_str =  eachRecord.values[ id_XB ].split(',')
        IJK_list , XB_list = [0]*3 , [0.0]*6
        for eachNum in range(3) :
            IJK_list[eachNum] = int( IJK_str[eachNum] )
        for eachNum in range(6) :
            XB_list[eachNum] = float( XB_str[eachNum] )
        #print IJK_list , XB_list
        MeshList .append( [ IJK_list , XB_list ] )

#print MeshList

# summ
NIList  = [0]* len(MeshList) 
NJList =NIList[:]
NKList = NIList[:]
NMList = NIList[:] 
#NIList , NJList ,NKList ,NMList   = [ [0]* len(MeshList) ]  * 4 
for numItem in range( len(MeshList) ) :
    NIList[numItem], NJList[numItem] , NKList[numItem] = MeshList[numItem][0][:]
    NMList[numItem] =  NIList[numItem] * NJList[numItem] * NKList[numItem] 
#print NIList , NJList ,NKList ,NMList 
maxone = max(NMList)
midone = sorted(NMList)[ len(MeshList)/2 ] 
minone = min(NMList)
print "Max one is : " , maxone  
print "mid one is "  , midone
print "unbalance : " , maxone/midone 

# cut the mesh by the min one 


## !!YOU CAN CHANGE CODES AFTER THIS LINE!!

tmplist = [] 
cutsize = minone / int(sys.argv[2] ) 
for itemI in range(len(MeshList)) :
    meshi = MeshList[itemI]
    if NMList[ itemI ] < cutsize :
        tmplist.append( meshRecordList[itemI] )
        continue # do not need cut cut
    meshi_P0 = [ meshi[1][0 ] , meshi[1][ 2] ,meshi[1][ 4 ] ] 
    meshi_P1 =  [ meshi[1][1 ] , meshi[1][ 3] ,meshi[1][ 5 ] ]
    box_get = divBox.Box( *meshi[0] ,PA=meshi_P0 ,PB=meshi_P1 )
    #print 'before cut : ', box_get.IJK , box_get.PA , box_get.PB
    cutlist = box_get.cuttest( cutsize  )
    if len( cutlist ) == 1 :
        tmplist.append( meshRecordList[itemI] ) 
        continue # could not cut  
    #print 'before cut :' ,
    meshRecordList[itemI].debugprint()
    loopindex=1
    for eachbox in cutlist :
        #print 'after cut : ', eachbox.IJK , eachbox.PA , eachbox.PB
        # build a list of new record 
        tmprecord = meshRecordList[itemI].Copy()
        #tmprecord.debugprint()#print tmprecord.Type ,    tmprecord.Text , tmprecord.Name , tmprecord.keys ,tmprecord.values 
        #tmprecord.
        tmprecord.setValue('ID', tmprecord.getValue('ID')[:-1] + '_cut' +  str( loopindex ) + '\'' )
        loopindex += 1
        tmprecord.setValue( 'IJK' , ','.join([ str(i) for i in eachbox.IJK  ]) ) 
        tmpXB = [ eachbox.PA[0] , eachbox.PB[0] , eachbox.PA[1] , eachbox.PB[1] ,  eachbox.PA[2] , eachbox.PB[2]  ] 
        tmprecord.setValue( 'XB' , ','.join( [ "%#.4g" % i for i in tmpXB  ]   ) )
        tmprecord.refreshText()
        tmplist.append( tmprecord )
        #tmprecord.debugprint()




	
## sort tmplist 
#def cmpmeshrecord( mesha , meshb  ):
#    
#    IJKa = sum( [  int(i) for i in  mesha.getValue('IJK').split(',') ] )
#    IJKb = sum(  [ int(i)  for i in  meshb.getValue('IJK').split(',') ] )
#    return cmp(IJKa , IJKb)
#
#tmplist.sort( cmp=cmpmeshrecord , reverse=True)

## !!YOU CAN CHANGE CODES ABOVE THIS LINE!!

# OUTPUT ! MUSK THE OLD ONE AND DISPLAY THE NEW ONE 
fpout = open(setting.file_out,'w')
haveprinted = False 
for eachrecord in recordList :
     if eachrecord.Type == 'COMM':
         fpout.write( eachrecord.Text )
         fpout.write('\n')
     elif eachrecord.Name != 'MESH' :
         fpout.writelines( eachrecord.Text )
         fpout.write('\n')
     elif haveprinted :
         continue
     else :
         # print the tmprecord
         haveprinted = True
         for recordnew in tmplist :
             fpout.writelines( recordnew.Text )
             fpout.write('\n')
        
        
#meshRecordList[1].Text="asdfadfaf"
#print recordList[8].Text 
