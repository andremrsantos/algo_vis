---
layout: post
title:  "JSNetworkX test"
description: ""
category: Graph 
tags:   [graph, api, jsnetworkx]
styles: [canvas/canvas]
js:     [vendor/d3.min, vendor/jsnetworkx]
---
<script type="text/javascript">
    $(function() {
        var G = jsnx.binomial_graph(6, 0.3);
        G.node[0].label = 'lol';
         
        jsnx.draw(G, {
            element: '#canvas',
            with_labels: true ,
            edge_style: {
                'stroke-width': 10
            },
            node_style: {
                stroke: 'none'
            }
        }, true);
    });
</script>
<div id="canvas"/>