---
layout: post
title:  "UniLight: A Unified Representation for Lighting"
date:   2025-10-01 13:56:59 +00:00
image: images/unilight.png
categories: research
author: "Zitian Zhang"
authors: "<strong>Zitian Zhang</strong>, Iliyan Georgiev, Michael Fischer, Yannick Hold-Geoffroy, Jean-François Lalonde, Valentin Deschaintre"
venue: "CVPR 2026"
arxiv: https://arxiv.org/abs/2512.04267v1
website: https://lvsn.github.io/UniLight/
---
This work proposes UniLight, a joint latent space as lighting representation, that unifies multiple modalities within a shared embedding. Modality-specific encoders for text, images, irradiance, and environment maps are trained contrastively to align their representations, with an auxiliary spherical-harmonics prediction task reinforcing directional understanding. Our multi-modal data pipeline enables large-scale training and evaluation across three tasks: lighting-based retrieval, environment-map generation, and lighting control in diffusion-based image synthesis.