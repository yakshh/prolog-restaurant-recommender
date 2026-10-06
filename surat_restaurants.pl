% Surat restaurant dataset (100 entries) for the Prolog recommender
% restaurant(Id, Name, Area, PrimaryCuisine, CostForTwoINR, VegType, AvgRating).
% veg_type: veg = pure vegetarian, nonveg = mainly non-veg, both = serves both / not stated (assumed)
% cuisine_tag(Id, Tag): all cuisine tags for a restaurant (use for flexible matching)
% avg_rating = mean of platform ratings (Google, TripAdvisor, Zomato, Swiggy, EazyDiner, magicpin)
% Data collected 4 Oct 2026 from search-indexed pages; prices and ratings change over time.

:- discontiguous restaurant/7, cuisine_tag/2, confidence/2.

restaurant(r01, 'Oran', adajan, multicuisine, 1400, both, 4.6).
restaurant(r02, 'The Bungalow Cafe', vesu, cafe, 1100, both, 4.3).
restaurant(r03, 'Vintage Asia (Surat Marriott)', city_light, asian, 3500, both, 4.8).
restaurant(r04, 'Table 101 (Surat Marriott)', city_light, multicuisine, 3000, both, 4.4).
restaurant(r05, 'Girnar Multi Cuisine Restaurant', adajan, multicuisine, 1000, both, 4.3).
restaurant(r06, 'Meraki The Coffee House', vesu, cafe, 600, both, 4.9).
restaurant(r07, 'Barbeque Nation (Parle Point)', athwa, bbq, 2000, both, 4.5).
restaurant(r08, 'Theobroma', vesu, bakery_dessert, 500, both, 4.6).
restaurant(r09, 'Spice Petals', vesu, multicuisine, 1000, both, 4.17).
restaurant(r10, 'Karanj', vesu, multicuisine, 1400, both, 4.8).
restaurant(r11, 'Si Nonna\'s - Sourdough Pizza', vesu, italian, 1000, veg, 4.3).
restaurant(r12, 'Urban Punjab', vesu, north_indian, 1000, both, 4.2).
restaurant(r13, 'Amar Restaurant & Juice Center', piplod, multicuisine, 600, veg, 4.3).
restaurant(r14, 'Daarji\'s Dhaba', piplod, north_indian, 750, nonveg, 4.4).
restaurant(r15, 'Patiala Shahi Tandoori Night', piplod, north_indian, 600, both, 4.2).
restaurant(r16, 'Zibrish Rooftop Dining Lounge', piplod, multicuisine, 1200, both, 4.4).
restaurant(r17, 'Spice Villa', piplod, multicuisine, 1000, veg, 4.33).
restaurant(r18, 'Simply South by Taste of Bhagwati', athwa, south_indian, 800, veg, 4.0).
restaurant(r19, 'Taste of Bhagwati (City Light)', city_light, multicuisine, 1000, veg, 4.1).
restaurant(r20, 'Bhai Bhai Dabeliwala', athwa, street_food, 300, veg, 4.8).
restaurant(r21, '365 The Travel Cafe', city_light, cafe, 600, veg, 4.8).
restaurant(r22, 'Achija Gujarati Thali', adajan, gujarati, 900, veg, 4.0).
restaurant(r23, 'Sugar N Spice', varachha, multicuisine, 600, both, 4.2).
restaurant(r24, 'Kamats', varachha, south_indian, 600, both, 4.0).
restaurant(r25, 'DVG Benne Dosa', adajan, south_indian, 600, veg, 4.05).
restaurant(r26, 'Thepla Junction', adajan, gujarati, 300, veg, 3.7).
restaurant(r27, 'The Robot Restaurant - The Yellow House', piplod, multicuisine, 1400, both, 4.0).
restaurant(r28, 'Pashto', piplod, north_indian, 1000, both, 4.0).
restaurant(r29, 'Pavilion Restaurant', vesu, multicuisine, 2000, veg, 4.55).
restaurant(r30, 'Midnight Chicken Center', althan, north_indian, 500, nonveg, 4.3).
restaurant(r31, 'Sasumaa Gujarati Thali', ring_road, gujarati, 680, veg, 4.05).
restaurant(r32, 'Kansar Gujarati Thali', nanpura, gujarati, 640, veg, 4.1).
restaurant(r33, 'Wok On Fire', athwa, chinese, 1300, veg, 4.25).
restaurant(r34, 'Sizzling Salsa', piplod, multicuisine, 1500, veg, 4.13).
restaurant(r35, 'Lake View Restaurant', piplod, north_indian, 1000, veg, 4.13).
restaurant(r36, 'Singh Saaab Di Rasoi', piplod, north_indian, 1000, both, 4.05).
restaurant(r37, 'Dil Se Re Restaurant', adajan, multicuisine, 1100, veg, 4.0).
restaurant(r38, 'Great Indian Tadka', pal, north_indian, 600, veg, 4.4).
restaurant(r39, 'Snap Kitchen', adajan, multicuisine, 700, both, 4.4).
restaurant(r40, 'Mexican Spicy Salsa', piplod, mexican, 500, veg, 4.4).
restaurant(r41, 'Coffee Culture', city_light, cafe, 500, both, 4.3).
restaurant(r42, 'The Lime Tree (Lords Plaza)', station_road, multicuisine, 1600, both, 4.5).
restaurant(r43, 'Silvernest Restaurant', athwa, north_indian, 600, veg, 3.9).
restaurant(r44, 'Sale & Pepe - Ristorante Italiano', piplod, italian, 1600, veg, 4.6).
restaurant(r45, 'East Asia', vesu, asian, 1000, veg, 4.15).
restaurant(r46, 'Mirch Masala', vesu, north_indian, 1000, both, 4.2).
restaurant(r47, 'The Old Roastery', vesu, cafe, 700, both, 4.6).
restaurant(r48, 'Zero The Restaurant', vesu, multicuisine, 1500, veg, 4.5).
restaurant(r49, 'Royal Maharaja Palace', vesu, multicuisine, 800, both, 4.5).
restaurant(r50, 'Leonardo Italian Mediterranean', piplod, italian, 1000, both, 4.3).
restaurant(r51, 'De\' Villa Garden Restro Lounge', adajan, multicuisine, 800, both, 4.05).
restaurant(r52, 'Jalaram Khichdi', majura_gate, gujarati, 400, veg, 4.1).
restaurant(r53, 'Avadh Family Restaurant', varachha, punjabi, 650, both, 4.4).
restaurant(r54, 'Bhai Bhai Omelette Center', nanpura, fast_food, 230, nonveg, 4.25).
restaurant(r55, 'Mysore Cafe', athwa, south_indian, 400, veg, 4.3).
restaurant(r56, 'Falafel Lovers', piplod, lebanese, 600, both, 4.2).
restaurant(r57, 'Dotivala Bakery', athwa, bakery_dessert, 170, veg, 4.2).
restaurant(r58, 'Levvel 5 Restaurant', adajan, multicuisine, 800, both, 4.5).
restaurant(r59, 'Golden Dragon', athwa, chinese, 700, both, 4.15).
restaurant(r60, 'Mumbai\'s Grill Fast Food', athwa, fast_food, 300, both, 4.4).
restaurant(r61, 'The Commoner\'s Kitchen', athwa, cafe, 800, both, 4.55).
restaurant(r62, 'Shah Jamnadas C. Ghariwala', chauta_bazaar, sweets, 300, veg, 4.4).
restaurant(r63, 'Blue Basil', magdalla, multicuisine, 900, both, 4.2).
restaurant(r64, 'Shree Sainath Snacks', nanpura, south_indian, 300, veg, 4.5).
restaurant(r65, 'Nini\'s Kitchen', piplod, multicuisine, 800, both, 4.1).
restaurant(r66, 'Geetha Restaurant', vesu, multicuisine, 600, both, 4.2).
restaurant(r67, 'Jani Farsan', althan, gujarati, 180, veg, 4.25).
restaurant(r68, 'Jaani Locha House', athwa, street_food, 280, veg, 4.3).
restaurant(r69, 'Mahesh Pavbhaji', athwa, street_food, 400, veg, 4.0).
restaurant(r70, 'Raju Chacha Vadapav', adajan, street_food, 80, veg, 4.4).
restaurant(r71, 'Shreeji Locho House', athwa, street_food, 220, veg, 4.5).
restaurant(r72, 'SurTEA', athwa, cafe, 80, veg, 4.5).
restaurant(r73, 'Ilyas Mama Chicken & Paratha Center', rander, north_indian, 320, nonveg, 4.2).
restaurant(r74, 'G.dada Farsan & Surti Rasoi', adajan, gujarati, 400, veg, 4.1).
restaurant(r75, 'Atul Bakery', varachha, bakery_dessert, 190, veg, 4.3).
restaurant(r76, 'Maakhan Bhog', vesu, sweets, 280, veg, 4.2).
restaurant(r77, 'Mahalaxmi Locho', athwa, street_food, 250, veg, 4.5).
restaurant(r78, 'Chaipartner', athwa, cafe, 220, veg, 4.8).
restaurant(r79, 'La Pino\'z Pizza (Udhana)', udhana, pizza, 550, both, 3.8).
restaurant(r80, 'Hajoori\'s Kulfi & Ice Cream', adajan, ice_cream, 50, veg, 4.6).
restaurant(r81, 'McDonald\'s (Ghod Dod Road)', ghod_dod_road, fast_food, 450, both, 4.25).
restaurant(r82, 'Together & Co. by Hilton', city_centre, multicuisine, 1800, both, 4.2).
restaurant(r83, 'Zaytun Falafel House', katargam, arabian, 800, both, 5.0).
restaurant(r84, 'Vellora Cafe and Restro', vesu, cafe, 800, both, 4.9).
restaurant(r85, 'Aroma of Hyderabad', piplod, biryani, 1000, both, 3.7).
restaurant(r86, 'Brew Circle by Kohi Aura', ifc, cafe, 1600, both, 4.0).
restaurant(r87, 'Tealogy', adajan, cafe, 400, veg, 4.0).
restaurant(r88, 'Chai Shai', vesu, cafe, 500, veg, 4.0).
restaurant(r89, 'Moti Mahal Tandoori Trail', adajan, north_indian, 800, both, 4.2).
restaurant(r90, 'Enaraa', piplod, pan_asian, 1200, both, 4.0).
restaurant(r91, 'Indian Chicken Express', vesu, mughlai, 700, nonveg, 4.3).
restaurant(r92, 'Pizzaiiolo - Wood Fired Pizza', dumas_road, pizza, 800, both, 4.2).
restaurant(r93, 'Sky Altitude', vesu, multicuisine, 600, both, 4.0).
restaurant(r94, 'Social Blend', mota_varachha, cafe, 900, both, 4.0).
restaurant(r95, 'DERO by Zero', dumas_road, multicuisine, 1500, both, 4.4).
restaurant(r96, 'Dosa Charcoal', katargam, south_indian, 550, veg, 3.7).
restaurant(r97, 'Masala Box by Richie Rich', athwa, north_indian, 600, veg, 4.7).
restaurant(r98, 'Zest House', athwa, multicuisine, 1400, both, 3.2).
restaurant(r99, 'New Surya Terrace Restaurant', mbh, north_indian, 1000, both, 3.5).
restaurant(r100, 'Ministry of Eggs', vesu, fast_food, 600, nonveg, 3.0).

cuisine_tag(r01, north_indian).
cuisine_tag(r01, chinese).
cuisine_tag(r01, pizza).
cuisine_tag(r02, cafe).
cuisine_tag(r02, pizza).
cuisine_tag(r02, beverages).
cuisine_tag(r03, asian).
cuisine_tag(r03, sushi).
cuisine_tag(r03, chinese).
cuisine_tag(r03, desserts).
cuisine_tag(r04, north_indian).
cuisine_tag(r04, continental).
cuisine_tag(r04, chinese).
cuisine_tag(r05, north_indian).
cuisine_tag(r05, chinese).
cuisine_tag(r05, gujarati).
cuisine_tag(r06, cafe).
cuisine_tag(r06, coffee).
cuisine_tag(r06, desserts).
cuisine_tag(r07, north_indian).
cuisine_tag(r07, bbq).
cuisine_tag(r07, kebab).
cuisine_tag(r07, biryani).
cuisine_tag(r08, bakery).
cuisine_tag(r08, desserts).
cuisine_tag(r09, north_indian).
cuisine_tag(r09, chinese).
cuisine_tag(r09, continental).
cuisine_tag(r09, desserts).
cuisine_tag(r09, mughlai).
cuisine_tag(r10, north_indian).
cuisine_tag(r10, biryani).
cuisine_tag(r10, continental).
cuisine_tag(r10, italian).
cuisine_tag(r10, mexican).
cuisine_tag(r10, asian).
cuisine_tag(r11, pizza).
cuisine_tag(r11, italian).
cuisine_tag(r11, coffee).
cuisine_tag(r12, north_indian).
cuisine_tag(r12, chinese).
cuisine_tag(r12, rolls).
cuisine_tag(r12, fast_food).
cuisine_tag(r13, multicuisine).
cuisine_tag(r13, juices).
cuisine_tag(r13, italian).
cuisine_tag(r13, chinese).
cuisine_tag(r14, north_indian).
cuisine_tag(r14, kebab).
cuisine_tag(r15, punjabi).
cuisine_tag(r15, mughlai).
cuisine_tag(r15, biryani).
cuisine_tag(r15, kebab).
cuisine_tag(r15, fast_food).
cuisine_tag(r16, multicuisine).
cuisine_tag(r16, rooftop).
cuisine_tag(r17, north_indian).
cuisine_tag(r17, indian).
cuisine_tag(r17, chinese).
cuisine_tag(r17, oriental).
cuisine_tag(r18, south_indian).
cuisine_tag(r18, chinese).
cuisine_tag(r18, north_indian).
cuisine_tag(r19, south_indian).
cuisine_tag(r19, chinese).
cuisine_tag(r19, north_indian).
cuisine_tag(r20, street_food).
cuisine_tag(r20, fast_food).
cuisine_tag(r20, gujarati).
cuisine_tag(r21, continental).
cuisine_tag(r21, multicuisine).
cuisine_tag(r22, gujarati).
cuisine_tag(r22, thali).
cuisine_tag(r23, chinese).
cuisine_tag(r23, north_indian).
cuisine_tag(r23, south_indian).
cuisine_tag(r23, shakes).
cuisine_tag(r24, north_indian).
cuisine_tag(r24, south_indian).
cuisine_tag(r25, south_indian).
cuisine_tag(r25, shakes).
cuisine_tag(r25, desserts).
cuisine_tag(r26, gujarati).
cuisine_tag(r26, desserts).
cuisine_tag(r27, north_indian).
cuisine_tag(r27, chinese).
cuisine_tag(r28, arabian).
cuisine_tag(r28, biryani).
cuisine_tag(r28, mughlai).
cuisine_tag(r28, north_indian).
cuisine_tag(r28, kebab).
cuisine_tag(r29, chinese).
cuisine_tag(r29, italian).
cuisine_tag(r29, mexican).
cuisine_tag(r29, indian).
cuisine_tag(r30, north_indian).
cuisine_tag(r30, mughlai).
cuisine_tag(r30, chinese).
cuisine_tag(r31, gujarati).
cuisine_tag(r31, thali).
cuisine_tag(r32, gujarati).
cuisine_tag(r32, thali).
cuisine_tag(r33, chinese).
cuisine_tag(r33, pan_asian).
cuisine_tag(r34, sizzlers).
cuisine_tag(r34, chinese).
cuisine_tag(r34, continental).
cuisine_tag(r34, mexican).
cuisine_tag(r34, italian).
cuisine_tag(r35, north_indian).
cuisine_tag(r35, chinese).
cuisine_tag(r35, biryani).
cuisine_tag(r35, fast_food).
cuisine_tag(r36, punjabi).
cuisine_tag(r36, chinese).
cuisine_tag(r37, north_indian).
cuisine_tag(r37, chinese).
cuisine_tag(r37, italian).
cuisine_tag(r37, asian).
cuisine_tag(r38, north_indian).
cuisine_tag(r39, gujarati).
cuisine_tag(r39, north_indian).
cuisine_tag(r39, biryani).
cuisine_tag(r39, chinese).
cuisine_tag(r39, italian).
cuisine_tag(r40, mexican).
cuisine_tag(r41, continental).
cuisine_tag(r41, indian).
cuisine_tag(r42, north_indian).
cuisine_tag(r42, chinese).
cuisine_tag(r42, bbq).
cuisine_tag(r42, buffet).
cuisine_tag(r43, north_indian).
cuisine_tag(r43, chinese).
cuisine_tag(r43, punjabi).
cuisine_tag(r44, italian).
cuisine_tag(r44, pizza).
cuisine_tag(r44, desserts).
cuisine_tag(r45, asian).
cuisine_tag(r45, continental).
cuisine_tag(r45, pizza).
cuisine_tag(r45, pasta).
cuisine_tag(r46, north_indian).
cuisine_tag(r46, mughlai).
cuisine_tag(r46, street_food).
cuisine_tag(r47, cafe).
cuisine_tag(r47, coffee).
cuisine_tag(r47, italian).
cuisine_tag(r47, pizza).
cuisine_tag(r48, asian).
cuisine_tag(r48, pizza).
cuisine_tag(r48, north_indian).
cuisine_tag(r48, continental).
cuisine_tag(r49, north_indian).
cuisine_tag(r49, multicuisine).
cuisine_tag(r50, italian).
cuisine_tag(r50, pizza).
cuisine_tag(r51, multicuisine).
cuisine_tag(r51, north_indian).
cuisine_tag(r51, continental).
cuisine_tag(r52, gujarati).
cuisine_tag(r52, north_indian).
cuisine_tag(r52, khichdi).
cuisine_tag(r53, north_indian).
cuisine_tag(r53, punjabi).
cuisine_tag(r53, chinese).
cuisine_tag(r54, fast_food).
cuisine_tag(r54, egg).
cuisine_tag(r54, street_food).
cuisine_tag(r55, south_indian).
cuisine_tag(r55, dosa).
cuisine_tag(r55, snacks).
cuisine_tag(r56, lebanese).
cuisine_tag(r56, mediterranean).
cuisine_tag(r56, multicuisine).
cuisine_tag(r57, bakery).
cuisine_tag(r57, sweets).
cuisine_tag(r57, snacks).
cuisine_tag(r58, multicuisine).
cuisine_tag(r58, continental).
cuisine_tag(r58, north_indian).
cuisine_tag(r58, asian).
cuisine_tag(r59, chinese).
cuisine_tag(r59, indo_chinese).
cuisine_tag(r60, fast_food).
cuisine_tag(r60, street_food).
cuisine_tag(r60, snacks).
cuisine_tag(r61, cafe).
cuisine_tag(r61, mediterranean).
cuisine_tag(r61, continental).
cuisine_tag(r62, sweets).
cuisine_tag(r62, desserts).
cuisine_tag(r62, gujarati).
cuisine_tag(r63, north_indian).
cuisine_tag(r63, chinese).
cuisine_tag(r63, multicuisine).
cuisine_tag(r64, south_indian).
cuisine_tag(r64, dosa).
cuisine_tag(r64, snacks).
cuisine_tag(r65, multicuisine).
cuisine_tag(r65, north_indian).
cuisine_tag(r65, chinese).
cuisine_tag(r66, north_indian).
cuisine_tag(r66, chinese).
cuisine_tag(r66, street_food).
cuisine_tag(r67, gujarati).
cuisine_tag(r67, farsan).
cuisine_tag(r67, snacks).
cuisine_tag(r68, street_food).
cuisine_tag(r68, locho).
cuisine_tag(r68, gujarati).
cuisine_tag(r69, street_food).
cuisine_tag(r69, pav_bhaji).
cuisine_tag(r69, fast_food).
cuisine_tag(r69, chinese).
cuisine_tag(r70, street_food).
cuisine_tag(r70, vada_pav).
cuisine_tag(r70, snacks).
cuisine_tag(r71, street_food).
cuisine_tag(r71, locho).
cuisine_tag(r71, gujarati).
cuisine_tag(r72, tea).
cuisine_tag(r72, cafe).
cuisine_tag(r72, snacks).
cuisine_tag(r73, north_indian).
cuisine_tag(r73, chicken).
cuisine_tag(r73, paratha).
cuisine_tag(r74, gujarati).
cuisine_tag(r74, farsan).
cuisine_tag(r74, surti).
cuisine_tag(r75, bakery).
cuisine_tag(r75, snacks).
cuisine_tag(r75, desserts).
cuisine_tag(r76, sweets).
cuisine_tag(r76, bakery).
cuisine_tag(r76, snacks).
cuisine_tag(r77, street_food).
cuisine_tag(r77, locho).
cuisine_tag(r77, gujarati).
cuisine_tag(r78, tea).
cuisine_tag(r78, cafe).
cuisine_tag(r78, snacks).
cuisine_tag(r79, pizza).
cuisine_tag(r79, italian).
cuisine_tag(r79, fast_food).
cuisine_tag(r80, ice_cream).
cuisine_tag(r80, kulfi).
cuisine_tag(r80, desserts).
cuisine_tag(r81, fast_food).
cuisine_tag(r81, burgers).
cuisine_tag(r82, multicuisine).
cuisine_tag(r82, italian).
cuisine_tag(r82, north_indian).
cuisine_tag(r82, south_indian).
cuisine_tag(r82, asian).
cuisine_tag(r82, biryani).
cuisine_tag(r82, desserts).
cuisine_tag(r83, arabian).
cuisine_tag(r83, lebanese).
cuisine_tag(r83, mediterranean).
cuisine_tag(r83, pizza).
cuisine_tag(r83, shakes).
cuisine_tag(r84, cafe).
cuisine_tag(r84, burgers).
cuisine_tag(r84, pizza).
cuisine_tag(r84, continental).
cuisine_tag(r84, north_indian).
cuisine_tag(r84, chinese).
cuisine_tag(r85, biryani).
cuisine_tag(r85, mughlai).
cuisine_tag(r85, north_indian).
cuisine_tag(r85, kebab).
cuisine_tag(r85, hyderabadi).
cuisine_tag(r86, cafe).
cuisine_tag(r86, coffee).
cuisine_tag(r86, italian).
cuisine_tag(r86, mexican).
cuisine_tag(r86, chinese).
cuisine_tag(r86, fast_food).
cuisine_tag(r87, tea).
cuisine_tag(r87, cafe).
cuisine_tag(r87, fast_food).
cuisine_tag(r87, pizza).
cuisine_tag(r87, shakes).
cuisine_tag(r88, tea).
cuisine_tag(r88, cafe).
cuisine_tag(r88, fast_food).
cuisine_tag(r88, pizza).
cuisine_tag(r88, shakes).
cuisine_tag(r89, north_indian).
cuisine_tag(r89, biryani).
cuisine_tag(r89, kebab).
cuisine_tag(r89, chinese).
cuisine_tag(r89, momos).
cuisine_tag(r90, pan_asian).
cuisine_tag(r90, japanese).
cuisine_tag(r90, biryani).
cuisine_tag(r91, mughlai).
cuisine_tag(r91, biryani).
cuisine_tag(r91, chinese).
cuisine_tag(r91, north_indian).
cuisine_tag(r91, afghani).
cuisine_tag(r92, pizza).
cuisine_tag(r92, italian).
cuisine_tag(r93, chinese).
cuisine_tag(r93, italian).
cuisine_tag(r93, north_indian).
cuisine_tag(r93, salad).
cuisine_tag(r94, cafe).
cuisine_tag(r94, desserts).
cuisine_tag(r94, italian).
cuisine_tag(r94, mexican).
cuisine_tag(r94, asian).
cuisine_tag(r94, continental).
cuisine_tag(r95, italian).
cuisine_tag(r95, north_indian).
cuisine_tag(r95, asian).
cuisine_tag(r95, continental).
cuisine_tag(r95, salad).
cuisine_tag(r95, desserts).
cuisine_tag(r96, south_indian).
cuisine_tag(r96, dosa).
cuisine_tag(r96, mexican).
cuisine_tag(r96, north_indian).
cuisine_tag(r97, north_indian).
cuisine_tag(r97, south_indian).
cuisine_tag(r97, fast_food).
cuisine_tag(r98, chinese).
cuisine_tag(r98, coffee).
cuisine_tag(r98, italian).
cuisine_tag(r98, north_indian).
cuisine_tag(r98, pizza).
cuisine_tag(r98, pasta).
cuisine_tag(r98, continental).
cuisine_tag(r99, biryani).
cuisine_tag(r99, chinese).
cuisine_tag(r99, north_indian).
cuisine_tag(r100, egg).
cuisine_tag(r100, chinese).
cuisine_tag(r100, fast_food).
cuisine_tag(r100, street_food).
cuisine_tag(r100, healthy).

confidence(r01, medium).
confidence(r02, medium).
confidence(r03, high).
confidence(r04, medium).
confidence(r05, high).
confidence(r06, low).
confidence(r07, high).
confidence(r08, high).
confidence(r09, high).
confidence(r10, low).
confidence(r11, medium).
confidence(r12, high).
confidence(r13, medium).
confidence(r14, medium).
confidence(r15, medium).
confidence(r16, medium).
confidence(r17, high).
confidence(r18, medium).
confidence(r19, medium).
confidence(r20, medium).
confidence(r21, medium).
confidence(r22, medium).
confidence(r23, medium).
confidence(r24, low).
confidence(r25, medium).
confidence(r26, low).
confidence(r27, low).
confidence(r28, low).
confidence(r29, high).
confidence(r30, medium).
confidence(r31, high).
confidence(r32, high).
confidence(r33, high).
confidence(r34, high).
confidence(r35, high).
confidence(r36, high).
confidence(r37, high).
confidence(r38, medium).
confidence(r39, medium).
confidence(r40, medium).
confidence(r41, medium).
confidence(r42, medium).
confidence(r43, high).
confidence(r44, medium).
confidence(r45, high).
confidence(r46, medium).
confidence(r47, medium).
confidence(r48, medium).
confidence(r49, low).
confidence(r50, low).
confidence(r51, high).
confidence(r52, medium).
confidence(r53, high).
confidence(r54, high).
confidence(r55, high).
confidence(r56, medium).
confidence(r57, medium).
confidence(r58, high).
confidence(r59, high).
confidence(r60, medium).
confidence(r61, high).
confidence(r62, high).
confidence(r63, medium).
confidence(r64, high).
confidence(r65, medium).
confidence(r66, high).
confidence(r67, medium).
confidence(r68, high).
confidence(r69, high).
confidence(r70, medium).
confidence(r71, medium).
confidence(r72, medium).
confidence(r73, medium).
confidence(r74, medium).
confidence(r75, medium).
confidence(r76, medium).
confidence(r77, medium).
confidence(r78, medium).
confidence(r79, medium).
confidence(r80, medium).
confidence(r81, high).
confidence(r82, low).
confidence(r83, low).
confidence(r84, low).
confidence(r85, low).
confidence(r86, low).
confidence(r87, low).
confidence(r88, low).
confidence(r89, low).
confidence(r90, low).
confidence(r91, low).
confidence(r92, low).
confidence(r93, low).
confidence(r94, low).
confidence(r95, low).
confidence(r96, low).
confidence(r97, low).
confidence(r98, low).
confidence(r99, low).
confidence(r100, low).
