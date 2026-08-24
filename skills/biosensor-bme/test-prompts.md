# biosensor-bme — Acceptance Test Prompts

40 test prompts across 9 categories. Run with:

```bash
opencode run --agent biosensor-bme --prompt "<prompt>" --title "oc-temp-biosensor-test"
```

Pass criteria: the agent responds with domain-accurate, cited (where relevant) guidance; for troubleshooting it diagnoses systematically; for design it includes controls/replicates/calibration.

## 1. Domain Advice (5)
1. "What are the main advantages of aptamers over antibodies for continuous wearable monitoring?"
2. "Compare sweat, interstitial fluid, and saliva as biofluids for a protein biomarker wearable — which should I choose for CRP?"
3. "Explain the trade-offs between signal-on and signal-off electrochemical aptamer sensors."
4. "What does 'regenerable aptamer' mean practically, and how many regeneration cycles are realistic?"
5. "When should I use a FET-based biosensor vs an electrochemical (SWV/EIS) sensor for sweat cortisol?"

## 2. Experiment Design (5)
6. "Design a complete calibration experiment for my CRP aptamer patch in artificial sweat — concentrations, replicates, blanks, and how to compute LOD."
7. "Plan a spike-and-recovery study in real sweat for a cortisol aptasensor."
8. "Design an experiment to determine the optimum aptamer-to-MCH ratio on a gold electrode."
9. "How do I set up a temperature and pH robustness study for a wearable patch (25–40 °C, pH 4.5–6.5)?"
10. "Design a selectivity panel to show my CRP aptamer binds mCRP but not dCRP, BSA, IgG, or lysozyme."

## 3. Troubleshooting (7)
11. "My SWV MB peak is tiny and noisy. Walk me through diagnosis."
12. "Blank electrodes show the same signal as CRP-spiked electrodes — what's happening?"
13. "Signal drifts continuously upward during 30-min monitoring. Causes and fixes?"
14. "My regenerated sensor loses 80% signal after 3 cycles. What should I check?"
15. "EIS shows very high Rct after immobilization — is my SAM too dense?"
16. "I get false positives in real sweat but clean results in buffer. Why?"
17. "MCH seems to be displacing my monothiol aptamer. What anchoring strategies should I switch to?"

## 4. Literature / State-of-the-Art (4)
18. "Summarize the 2025–2026 landscape of sweat-based CRP detection."
19. "What's the latest on microneedle interstitial fluid sensors for continuous protein monitoring?"
20. "How does Persperity Health's estradiol sensor work and what design ideas can I borrow for CRP?"
21. "What is the InflaStat CRP patch and what are its calibration and microfluidic design principles?"

## 5. Computational Workflows (4)
22. "What are the correct AptaLoop MAWS parameters for generating a 31-nt ssDNA aptamer for mCRP?"
23. "Walk me through the HDOCK pipeline for the 50-mer+PK aptamer against mCRP 1B09 chain A, including PDB prep."
24. "How do I compare HDOCK scores across three aptamers fairly?"
25. "What's the role of CD spectroscopy in validating pseudoknot switching, and what is an isosbestic point?"

## 6. Materials & Instrumentation (4)
26. "Recommend a handheld potentiostat under $5k for SWV/DPV/EIS with screen-printed electrodes."
27. "What's the difference between monothiol, dithiol/DTPA, and alkyne-gold anchoring for sensor lifetime?"
28. "Which screen-printed electrode vendors should I consider for aptamer biosensors?"
29. "What blocking agents (MCH, PEG-thiol, zwitterionic) are best for antifouling in sweat?"

## 7. Safety & Ethics (3)
30. "What safety precautions do I need for piranha solution when cleaning gold electrodes?"
31. "What regulatory considerations apply to a research-stage sweat CRP patch before clinical claims?"
32. "Is it ethical/valid to claim sweat CRP correlates with serum CRP without a clinical study? What do I need?"

## 8. Collaboration / Data Analysis (4)
33. "Here are my SWV peak currents vs CRP concentration (0, 1, 10, 100, 1000 pM): 1.2, 1.5, 2.1, 3.4, 5.0 µA. Compute the calibration curve, LOD, and linear range."
34. "Draft a methods paragraph for an aptamer immobilization protocol suitable for a paper."
35. "Turn my experimental validation plan into a Gantt-style timeline with priorities."
36. "Help me interpret a CD spectrum that shows no switch when I add mCRP — what experiments next?"

## 9. Continuous Self-Update (4)
37. "What are the latest (2026) advances in stretchable sweat sensor materials?"
38. "Search for any new commercial wearable sweat sensors announced in the last 6 months."
39. "Is there any new review of electrochemical aptamer sensors for continuous monitoring published in 2025–2026?"
40. "What new potentiostats or low-cost open-source electrochemistry hardware appeared recently?"

---

## Negative test (should NOT trigger this agent strongly)
- "Can you help me deploy a Django app to DigitalOcean?" → should not activate biosensor-bme.
- "Explain Kubernetes ingress controllers." → should not activate.
