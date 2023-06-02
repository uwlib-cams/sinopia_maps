# Pre-cataloging decisions: choosing templates for describing aggregates

## Option A 
- Describe one or more of the expressions that are aggregated and the works realized by the expressions. 
- Use template [UWSINOPIA:WAU:rdaExpression:printMonograph:CAMS](https://uwlib-cams.github.io/sinopia_maps/html/UWSINOPIA_WAU_rdaExpression_printMonograph_CAMS.html) for describing an aggregated expression. 
- Use template [UWSINOPIA:WAU:rdaWork:printMonograph:CAMS](https://uwlib-cams.github.io/sinopia_maps/html/UWSINOPIA_WAU_rdaWork_printMonograph_CAMS.html) for describing a work realized by an aggregated expression. 
<br></br>
- Relate the manifestation to an aggregated expression using Manifestation: expression manifested. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-cf0b18a4-5a55-3358-94b0-2d4fb5449314/div_txc_vr1_ffb). 
- Relate an aggregated expression to the manifestation using Expression: manifestation of expression. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-f2747cbc-74d2-3131-a94b-e30effad9d09/div_wb5_l2h_lhb). 
- Relate an aggregated expression to the work realized by the expression using Expression: work expressed. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-f2747cbc-74d2-3131-a94b-e30effad9d09/div_tdm_wdh_lhb). 
- Relate a work to an aggregated expression that realizes it using Work: expression of work. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-4d4d3f5b-8d94-3ee5-89d8-241a98366db4/div_msj_sfh_lhb). 
### Recommended for: 
- An augmentation aggregate with only one primary expression. 
- A collection or parallel aggregate where no more than three (primary) expressions are aggregated. 

## Option B 
- Describe the aggregating work without describing any expression. 
- Use template [UWSINOPIA:WAU:rdaWork:aggregating_printMonograph:CAMS](https://uwlib-cams.github.io/sinopia_maps/html/UWSINOPIA_WAU_rdaWork_aggregating_printMonograph_CAMS.html) for describing the aggregating work. 
<br></br>
- Relate the manifestation to the aggregating work using Manifestation: work manifested. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-cf0b18a4-5a55-3358-94b0-2d4fb5449314/div_gml_qm4_j3b).
- Relate the aggregating work to the manifestation using Work: manifestation of work. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-4d4d3f5b-8d94-3ee5-89d8-241a98366db4/div_vfh_zfh_lhb).
<br></br>
- Record the attributes of one or more of the expressions that are aggregated using representative expression elements of the aggregating work. See [Toolkit guidance](https://access.rdatoolkit.org/en-US_ala-4d4d3f5b-8d94-3ee5-89d8-241a98366db4/div_dv4_rvn_2fb). 
<!-- - Collocate aggregating works that belong in the same work group using Work: authorized access point for work group or Work: identifier for work group. See [Toolkit guidance](https://access.rdatoolkit.org/en-US_ala-4d4d3f5b-8d94-3ee5-89d8-241a98366db4/section_y4p_p24_2fb). -->
- Record a creator of the aggregating work using Work: creator agent of work or Work: aggregator agent or a more appropriate narrower element. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-4d4d3f5b-8d94-3ee5-89d8-241a98366db4/div_dv4_rvn_2fb). 
<br></br>
- Record a creator of one or more of the expressions or works that are aggregated using Manifestation: contributor agent to aggregate. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-cf0b18a4-5a55-3358-94b0-2d4fb5449314/div_pd1_wr1_ffb). 
- Do not record a creator of one or more of the works that are aggregated as a creator of the aggregating work, unless they happen to be the same agent. 
### Recommended for: 
- A collection aggregate where more than three (primary) expressions are aggregated. 

## Option C 
- Describe the aggregating work without describing the aggregating expression. 
- Also describe one or more of the expressions that are aggregated and the works realized by the expressions. 
<br></br>
- For guidance on describing the aggregating work, see Option B. 
- For guidance on describing an aggregated expression and the work realized, see option A. 
### Recommended for: 
- A collection aggregate where more than three (primary) expressions are aggregated, and a creator of one or more of the expressions or works that are aggregated is deemed useful to users. 
- A parallel aggregate where more than three (primary) expressions are aggregated. When describing aggregated expressions, describe the original expression, if present, and at least the first derivative expression in the resource. 

## Option D (Apply with caution) 
- Describe the aggregating work and the aggregating expression. 
- Use template [UWSINOPIA:WAU:rdaExpression:aggregating_printMonograph:CAMS](https://uwlib-cams.github.io/sinopia_maps/html/UWSINOPIA_WAU_rdaExpression_aggregating_printMonograph_CAMS.html) for describing the aggregating expression. 
- Also describe one or more of the expressions that are aggregated and the works realized by the expressions. 
<br></br>
- Relate the aggregating expression to the manifestation using Expression: manifestation of expression. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-f2747cbc-74d2-3131-a94b-e30effad9d09/div_wb5_l2h_lhb). 
- Relate the aggregating expression to the aggregating work using Expression: work expressed. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-f2747cbc-74d2-3131-a94b-e30effad9d09/div_tdm_wdh_lhb). 
- Relate the aggregating expression to one or more of the expressions that are aggregated using Expression: aggregates. See [Toolkit option](https://access.rdatoolkit.org/en-US_ala-f2747cbc-74d2-3131-a94b-e30effad9d09/div_uwg_5tt_2fb). 
<br></br>
- For guidance on describing the aggregating work, see Option B. 
- Ror guidance on describing an aggregated expression and the work realized, see option A. 
### Not recommended
Only describe the aggregating expression when the same aggregating work (and hence the same aggregating expression) is manifested in multiple manifestations. Consider the possible minor differences in augmenting content when determining whether two aggregating works are the same. 
