from __future__ import division
from collections import defaultdict
import snap
import numpy as np

G1 = snap.LoadEdgeList(snap.PUNGraph, "com-lj.all.cmty.txt", 0, 1)
NodeIdList = snap.TIntV()
CmtyV = snap.TCnComV()
modularity = snap.CommunityCNM(G1, CmtyV)
NodesList = list()
CommunityCount = 0
for CnCom in CmtyV:
    CommunityCount += 1
    NodesList.append(CnCom.Len())
    print "Size of the component: %d" % CnCom.Len()
print "The number of Community is %d" % CommunityCount
Community = 0
SubGraphVector = snap.TIntV()
d = defaultdict(list)
for Cmty in CmtyV:
    Community += 1
    print "Community: %d" % Community
    for NI in Cmty:
        d[Community].append(NI)
        NodeIdList.Add(NI)

    SubGraph = snap.GetSubGraph(G1,NodeIdList)
    diam = snap.GetBfsFullDiam(SubGraph, 100, False)
    print "The diametre is %d" % diam
    DegToCCfV = snap.TFltPrV()
    DegList = list()
    result = snap.GetClustCfAll(SubGraph, DegToCCfV)
    for item in DegToCCfV:
        DegList.append(item.GetVal1())
        #print "degree: %d, clustering coefficient: %f" % (item.GetVal1(), item.GetVal2())
    print "average clustering coefficient", result[0]
    print "closed triads", result[1]
    print "open triads", result[2]
    NumTriadEdges = snap.GetTriadEdges(SubGraph)
    print "The number of TriadEdges is %d" % NumTriadEdges
    CountEdges = snap.CntUniqUndirEdges(SubGraph)
    print "Directed Graph: Count of undirected edges is %d" % CountEdges
    CountNodes = SubGraph.GetNodes()
    InternalDensity = CountEdges / (CountNodes * (CountNodes - 1) * 0.5)
    print "The Internal Density is %f" % InternalDensity
    AvgDeg = 2 * CountEdges / CountNodes
    print "The Average Degree is %f" % AvgDeg
    MedianDegree = np.median(DegList)
    print "The Median Degree is %d" % MedianDegree
    TPR = NumTriadEdges / CountEdges
    print "The Triangle Participation Rate is %d" % TPR
    NodeIdList.Clr()
print "The modularity of the network is %f" % modularity



