import networkx as nx
from networkx.algorithms import isomorphism

def match_kind(n1, n2):
    return n1["kind"] == n2["kind"]

def find_mapping(phy, log, node_match=match_kind):
    def annotate(nxg, dotg):
        for e in list(nxg.edges):
            s, d = e
            nxg.nodes[s]["kind"] = "port"
            nxg.nodes[d]["kind"] = "port"

            sn, sp = s.split(":")
            dn, dp = d.split(":")

            try:
                sk = dotg.get_node(sn)[0].get_attributes()["kind"]
            except:
                raise ValueError("\"{}\"'s kind is not known".format(sn))

            try:
                dk = dotg.get_node(dn)[0].get_attributes()["kind"]
            except:
                raise ValueError("\"{}\"'s kind is not known".format(dn))

            nxg.add_node(sn, kind=sk)
            nxg.add_edge(sn, s)
            nxg.add_node(dn, kind=dk)
            nxg.add_edge(dn, d)

    phyedges = [(e.get_source(), e.get_destination()) for e in phy.get_edges()]
    logedges = [(e.get_source(), e.get_destination()) for e in log.get_edges()]

    phyedges.sort()
    logedges.sort()
    nxphy = nx.Graph(phyedges)
    nxlog = nx.Graph(logedges)
    annotate(nxphy, phy)
    annotate(nxlog, log)

    nxmap = isomorphism.GraphMatcher(nxphy, nxlog, node_match=node_match)
    if nxmap.subgraph_is_isomorphic():
        return { v: k for (k, v) in nxmap.mapping.items() }

    return None
