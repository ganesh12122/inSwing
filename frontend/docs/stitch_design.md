<!-- Auth Landing -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>inSwing - Auth Landing</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-container-low": "#171d18",
                        "inverse-on-surface": "#2c322c",
                        "on-primary-fixed": "#00210c",
                        "secondary-fixed-dim": "#c3c7cc",
                        "tertiary-container": "#df6d7f",
                        "tertiary-fixed": "#ffd9dc",
                        "primary-container": "#3ca360",
                        "inverse-surface": "#dfe4dc",
                        "on-surface": "#dfe4dc",
                        "on-error-container": "#ffdad6",
                        "surface": "#0f1510",
                        "on-primary-fixed-variant": "#005227",
                        "tertiary": "#ffb2bb",
                        "on-surface-variant": "#becabc",
                        "outline": "#889488",
                        "on-primary": "#003919",
                        "on-primary-container": "#003115",
                        "error-container": "#93000a",
                        "on-tertiary-fixed": "#400011",
                        "primary": "#75db92",
                        "inverse-primary": "#006d36",
                        "on-error": "#690005",
                        "on-tertiary": "#630b23",
                        "surface-tint": "#75db92",
                        "surface-container-lowest": "#0a0f0b",
                        "on-secondary-fixed-variant": "#42474b",
                        "secondary-container": "#42474b",
                        "on-secondary-fixed": "#171c20",
                        "surface-container-high": "#262b26",
                        "surface-variant": "#303630",
                        "secondary": "#c3c7cc",
                        "error": "#ffb4ab",
                        "primary-fixed": "#91f8ac",
                        "on-secondary-container": "#b1b6ba",
                        "on-background": "#dfe4dc",
                        "secondary-fixed": "#dfe3e8",
                        "on-secondary": "#2c3135",
                        "surface-container-highest": "#303630",
                        "surface-bright": "#353b35",
                        "on-tertiary-fixed-variant": "#812438",
                        "tertiary-fixed-dim": "#ffb2bb",
                        "background": "#0f1510",
                        "surface-dim": "#0f1510",
                        "surface-container": "#1b211c",
                        "outline-variant": "#3e4a3f",
                        "on-tertiary-container": "#59031c",
                        "primary-fixed-dim": "#75db92"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "container-padding": "16px",
                        "lg": "24px",
                        "sm": "8px",
                        "md": "16px",
                        "base": "8px",
                        "xl": "32px",
                        "gutter": "12px",
                        "xs": "4px"
                    },
                    "fontFamily": {
                        "label-caps": ["Inter"],
                        "score-sub": ["JetBrains Mono"],
                        "body-sm": ["Inter"],
                        "h2": ["Inter"],
                        "h1": ["Inter"],
                        "body-md": ["Inter"],
                        "score-display": ["JetBrains Mono"]
                    },
                    "fontSize": {
                        "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                        "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
                    }
                },
            },
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            background-color: #0c1821;
        }
        .broadcast-mesh {
            background-image: radial-gradient(circle at 2px 2px, #1e2d3d 1px, transparent 0);
            background-size: 24px 24px;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="antialiased selection:bg-primary selection:text-on-primary">
<main class="relative min-h-screen flex flex-col items-center justify-center overflow-hidden broadcast-mesh">
<div class="absolute top-0 left-0 w-full h-full opacity-20 pointer-events-none">
<div class="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] rounded-full bg-primary-container blur-[120px]"></div>
<div class="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] rounded-full bg-tertiary-container blur-[120px] opacity-30"></div>
</div>
<section class="z-10 w-full max-w-md px-container-padding flex flex-col items-center">
<div class="relative group mb-xl">
<div class="absolute -inset-1 bg-primary rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"></div>
<div class="relative flex items-center justify-center w-32 h-32 bg-[#1B8A4A] rounded-full shadow-2xl border-4 border-[#2A3A4A]">
<span class="text-white font-score-display text-[64px] tracking-tighter italic">iS</span>
</div>
</div>
<div class="text-center mb-xl">
<h1 class="font-h1 text-[40px] text-white tracking-tight leading-none mb-sm">
                    inSwing
                </h1>
<p class="font-body-md text-on-surface-variant tracking-wide uppercase text-sm font-semibold opacity-80">
                    Professional Cricket Scoring
                </p>
</div>
<div class="w-full space-y-md">
<button class="w-full h-14 bg-[#1B8A4A] text-[#E8ECF1] font-h2 rounded-lg flex items-center justify-center shadow-lg transition-transform active:scale-[0.98]">
                    Login
                </button>
<button class="w-full h-14 bg-surface-container border border-[#2A3A4A] text-on-surface font-h2 rounded-lg flex items-center justify-center transition-all hover:bg-surface-container-high active:scale-[0.98]">
                    Register
                </button>
</div>
<div class="mt-xl flex flex-col items-center space-y-sm">
<div class="flex items-center gap-base">
<div class="h-[1px] w-8 bg-[#2A3A4A]"></div>
<span class="font-label-caps text-on-surface-variant opacity-60">BROADCAST PARTNER</span>
<div class="h-[1px] w-8 bg-[#2A3A4A]"></div>
</div>
<div class="flex gap-md opacity-40 grayscale contrast-125">
<img class="h-6 w-auto object-contain" data-alt="A professional sports broadcasting network logo displayed in a minimalist monochrome style. The design is sleek and modern, fitting into a high-end digital command center aesthetic. The lighting is low-key, emphasizing sharp technical lines and professional data utility. This element represents the authoritative presence of international cricket media coverage." src="https://lh3.googleusercontent.com/aida-public/AB6AXuA74k2URbEIHrlFReiWDnVZrP9iEgzOflpD181pEETqyIN7kNSWS8PEXChw2b0CME0GMR7F65rEfZerIbN-OF-OPN4e6Gm8tx8IZuYmrWSw-PotYrwzJJpa_1F4HzEhtvxU1-0TZ63E2UAoDSqw-RI3fk97paD_CkTW1DnZaT9aaB0--cTOZKbGgppXhPhduby3LNZflQDY5ZP8A4in3kYJ0fZxOE_gZ86LrEbhrlw0gjHdJdAc9Ug0VMad_kPiuoPaswTL4j3x6oc"/>
<img class="h-6 w-auto object-contain" data-alt="An official cricket federation insignia rendered in a flat, high-contrast dark mode style. The aesthetic is professional and athletic, suggesting official sanctioning and high-stakes performance. It is placed within a dark, moody UI environment characterized by deep navy backgrounds and crisp green accents. The overall mood is one of elite sports management and technical precision." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAPIaR9qP8aFLnO68Zdcs-XzeeYHvRhi-CCrIF3HqMkMpuZRVQ5moMdPsYrtMcKDd0BSaRzqyjI2rpmynhfVmiRH2FjrbXyoB4DTXrWPqSyY3wWBdvBoTEHGm-L1kTwx7ZrpciNTIEHxjkHT6f5TqbgGeNYt68cMtHApbJf3RmPimzorLmucE2BbvGgnb2FuTal9GHw6Cy_Xu3aeKsg99qU9qZRG9_J7t9xhXxIMrzmWbCp-9rGKfSHVIvz2DaRg48nZQ8DwuNEm_M"/>
</div>
</div>
</section>
<div class="absolute bottom-md text-center">
<p class="font-label-caps text-[10px] text-on-surface-variant opacity-40">
                © 2024 INSWING BROADCAST TECHNOLOGIES • v4.2.0
            </p>
</div>
</main>
<div class="fixed inset-0 pointer-events-none border-[1px] border-white/5 z-50"></div>
</body></html>

<!-- Dashboard -->
<!DOCTYPE html><html class="dark" lang="en"><head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-container-low": "#171d18",
                    "inverse-on-surface": "#2c322c",
                    "on-primary-fixed": "#00210c",
                    "secondary-fixed-dim": "#c3c7cc",
                    "tertiary-container": "#df6d7f",
                    "tertiary-fixed": "#ffd9dc",
                    "primary-container": "#3ca360",
                    "inverse-surface": "#dfe4dc",
                    "on-surface": "#dfe4dc",
                    "on-error-container": "#ffdad6",
                    "surface": "#0f1510",
                    "on-primary-fixed-variant": "#005227",
                    "tertiary": "#ffb2bb",
                    "on-surface-variant": "#becabc",
                    "outline": "#889488",
                    "on-primary": "#003919",
                    "on-primary-container": "#003115",
                    "error-container": "#93000a",
                    "on-tertiary-fixed": "#400011",
                    "primary": "#75db92",
                    "inverse-primary": "#006d36",
                    "on-error": "#690005",
                    "on-tertiary": "#630b23",
                    "surface-tint": "#75db92",
                    "surface-container-lowest": "#0a0f0b",
                    "on-secondary-fixed-variant": "#42474b",
                    "secondary-container": "#42474b",
                    "on-secondary-fixed": "#171c20",
                    "surface-container-high": "#262b26",
                    "surface-variant": "#303630",
                    "secondary": "#c3c7cc",
                    "error": "#ffb4ab",
                    "primary-fixed": "#91f8ac",
                    "on-secondary-container": "#b1b6ba",
                    "on-background": "#dfe4dc",
                    "secondary-fixed": "#dfe3e8",
                    "on-secondary": "#2c3135",
                    "surface-container-highest": "#303630",
                    "surface-bright": "#353b35",
                    "on-tertiary-fixed-variant": "#812438",
                    "tertiary-fixed-dim": "#ffb2bb",
                    "background": "#0f1510",
                    "surface-dim": "#0f1510",
                    "surface-container": "#1b211c",
                    "outline-variant": "#3e4a3f",
                    "on-tertiary-container": "#59031c",
                    "primary-fixed-dim": "#75db92"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "container-padding": "16px",
                    "lg": "24px",
                    "sm": "8px",
                    "md": "16px",
                    "base": "8px",
                    "xl": "32px",
                    "gutter": "12px",
                    "xs": "4px"
            },
            "fontFamily": {
                    "label-caps": ["Inter"],
                    "score-sub": ["JetBrains Mono"],
                    "body-sm": ["Inter"],
                    "h2": ["Inter"],
                    "h1": ["Inter"],
                    "body-md": ["Inter"],
                    "score-display": ["JetBrains Mono"]
            },
            "fontSize": {
                    "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                    "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            background-color: #0c1821; /* Level 0 Base from Style Guidance */
            color: #dfe4dc;
        }
        .broadcast-panel {
            background-color: #162029; /* Level 1 Surface */
            border: 1px solid #2a3a4a; /* Precise border from Guidance */
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="font-body-md antialiased selection:bg-primary-container selection:text-on-primary-container">
<!-- TopAppBar -->
<header class="bg-white dark:bg-slate-950 border-b border-slate-200 dark:border-slate-800 docked full-width top-0 z-40">
<div class="flex justify-between items-center w-full px-4 h-16">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-emerald-600 dark:text-emerald-500" data-icon="sports_cricket">sports_cricket</span>
<h1 class="text-xl font-black italic text-emerald-600 dark:text-emerald-500 font-sans tracking-tight">inSwing</h1>
</div>
<div class="flex items-center gap-2">
<button class="p-2 rounded-full hover:bg-slate-100 dark:hover:bg-slate-900 transition-all duration-200 ease-in-out">
<span class="material-symbols-outlined text-slate-500 dark:text-slate-400" data-icon="notifications">notifications</span>
</button>
</div>
</div>
</header>
<main class="pb-32 pt-6 px-container-padding max-w-md mx-auto">
<!-- Welcome Header -->
<section class="mb-lg">
<h2 class="font-h1 text-h1 text-on-surface">Hello, Rohit!</h2>
<p class="font-body-sm text-body-sm text-on-surface-variant">Ready for today's innings?</p>
</section>
<!-- Stats Grid (Bento Style) -->
<section class="grid grid-cols-3 gap-gutter mb-lg">
<div class="broadcast-panel rounded-xl p-md flex flex-col items-center justify-center text-center">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Matches</span>
<span class="font-score-sub text-score-sub text-primary">24</span>
</div>
<div class="broadcast-panel rounded-xl p-md flex flex-col items-center justify-center text-center">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Runs</span>
<span class="font-score-sub text-score-sub text-primary">842</span>
</div>
<div class="broadcast-panel rounded-xl p-md flex flex-col items-center justify-center text-center">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-xs">Wickets</span>
<span class="font-score-sub text-score-sub text-primary">12</span>
</div>
</section>
<!-- Live Section -->
<section class="mb-lg">
<div class="flex items-center justify-between mb-sm">
<h3 class="font-label-caps text-label-caps text-on-surface">Live Now</h3>
<div class="flex items-center gap-2 bg-error px-2 py-0.5 rounded-full">
<span class="w-1.5 h-1.5 bg-white rounded-full animate-pulse"></span>
<span class="font-label-caps text-[10px] text-on-error uppercase">Live</span>
</div>
</div>
<div class="broadcast-panel rounded-xl overflow-hidden relative">
<div class="absolute inset-0 opacity-10 pointer-events-none" data-alt="A cinematic wide-angle shot of a professional cricket stadium at dusk, with stadium lights illuminating the lush green field against a deep blue sky. The visual style is high-contrast and atmospheric, echoing a premium broadcast television aesthetic. Dark shadows and vibrant greens dominate the palette, creating a high-stakes, professional sporting environment." style="background-image: url(&quot;https://lh3.googleusercontent.com/aida-public/AB6AXuDNWydqqh4vBQPsiEWebRTkB1_j7oFyKKHDoDrRD6-U4675u2d4TpN7rnKIdV_9HAkUTFvbv1xdg0h5k3v0gaf95Ri9oOqY8LuPyJhrCk2eYJuY9nz2_Q372ceWvgBVglfkOGBLuek8ytQPmqpsFtYhDKufMSuiqMEZqjvq4dzhLRL_hbia4h7kI9jgZZJ4NtuC_PbDl3UMU0Z0Egm60lJq4KTzfAb3ByamjGQKsLAtBLEnLcW9ZC2_LQcBRrdRt2g4QSV6XJRSvnM&quot;); background-size: cover; background-position: center center;"></div>
<div class="p-md relative z-10">
<div class="flex justify-between items-end mb-md">
<div class="flex flex-col">
<span class="font-label-caps text-label-caps text-on-surface-variant">Team A</span>
<span class="font-score-display text-score-display text-white">184/4</span>
</div>
<div class="text-center font-label-caps text-label-caps text-on-surface-variant pb-2">VS</div>
<div class="flex flex-col items-end">
<span class="font-label-caps text-label-caps text-on-surface-variant">Team B</span>
<span class="font-score-display text-score-display text-white"><br></span>
</div>
</div>
<div class="border-t border-outline-variant pt-md flex justify-between items-center">
<div class="flex flex-col">
<span class="font-body-sm text-body-sm text-on-surface-variant">Over 18.2</span>
<span class="font-label-caps text-label-caps text-primary">CRR: 10.04</span>
</div>
<div class="flex gap-2">
<span class="w-8 h-8 rounded-full border border-outline flex items-center justify-center font-score-sub text-sm text-white">4</span>
<span class="w-8 h-8 rounded-full border border-outline flex items-center justify-center font-score-sub text-sm text-white">.</span>
<span class="w-8 h-8 rounded-full border border-outline flex items-center justify-center font-score-sub text-sm text-white">6</span>
<span class="w-8 h-8 rounded-full border border-primary-container bg-primary-container/20 flex items-center justify-center font-score-sub text-sm text-primary">W</span>
</div>
</div>
</div>
</div>
</section>
<!-- Recent Matches -->
<section class="mb-lg">
<h3 class="font-label-caps text-label-caps text-on-surface mb-sm">Recent Matches</h3>
<div class="space-y-sm">
<!-- Match 1 -->
<div class="broadcast-panel rounded-xl p-md flex items-center justify-between">
<div class="flex-1">
<div class="flex items-center gap-2 mb-1">
<span class="font-body-md text-body-md font-bold">Lords XI</span>
<span class="text-on-surface-variant font-body-sm">152/8</span>
</div>
<div class="flex items-center gap-2">
<span class="font-body-md text-body-md font-bold">Oval Strikers</span>
<span class="text-primary font-body-sm">153/4</span>
</div>
</div>
<div class="text-right">
<span class="block font-label-caps text-[10px] text-on-surface-variant mb-1 uppercase">Final</span>
<span class="block font-label-caps text-[10px] text-primary">WON BY 6 WKTS</span>
</div>
</div>
<!-- Match 2 -->
<div class="broadcast-panel rounded-xl p-md flex items-center justify-between">
<div class="flex-1">
<div class="flex items-center gap-2 mb-1">
<span class="font-body-md text-body-md font-bold">Warriors</span>
<span class="text-primary font-body-sm">210/3</span>
</div>
<div class="flex items-center gap-2">
<span class="font-body-md text-body-md font-bold">Titans</span>
<span class="text-on-surface-variant font-body-sm">188/9</span>
</div>
</div>
<div class="text-right">
<span class="block font-label-caps text-[10px] text-on-surface-variant mb-1 uppercase">Final</span>
<span class="block font-label-caps text-[10px] text-primary">WON BY 22 RUNS</span>
</div>
</div>
</div>
</section>
<!-- Quick Action FAB -->
<button class="fixed bottom-24 right-4 w-14 h-14 rounded-full bg-primary-container text-on-primary-container shadow-xl flex items-center justify-center active:scale-95 transition-transform z-50">
<span class="material-symbols-outlined text-3xl" data-icon="add_circle">add_circle</span>
</button>
</main>
<!-- BottomNavBar -->
<nav class="bg-white dark:bg-slate-950 border-t border-slate-200 dark:border-slate-800 fixed bottom-0 left-0 w-full flex justify-around items-center h-20 pb-safe px-2 z-50 shadow-lg dark:shadow-none">
<a class="flex flex-col items-center justify-center text-emerald-600 dark:text-emerald-500 scale-110 duration-150" href="#">
<span class="material-symbols-outlined" data-icon="home" style="font-variation-settings: &quot;FILL&quot; 1;">home</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Home</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="sports_cricket">sports_cricket</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Matches</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="add_circle">add_circle</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">New Match</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="group">group</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Connections</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="person">person</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Profile</span>
</a>
</nav>


</body></html>

<!-- Scoring Console -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "surface-container-low": "#171d18",
                      "inverse-on-surface": "#2c322c",
                      "on-primary-fixed": "#00210c",
                      "secondary-fixed-dim": "#c3c7cc",
                      "tertiary-container": "#df6d7f",
                      "tertiary-fixed": "#ffd9dc",
                      "primary-container": "#3ca360",
                      "inverse-surface": "#dfe4dc",
                      "on-surface": "#dfe4dc",
                      "on-error-container": "#ffdad6",
                      "surface": "#0f1510",
                      "on-primary-fixed-variant": "#005227",
                      "tertiary": "#ffb2bb",
                      "on-surface-variant": "#becabc",
                      "outline": "#889488",
                      "on-primary": "#003919",
                      "on-primary-container": "#003115",
                      "error-container": "#93000a",
                      "on-tertiary-fixed": "#400011",
                      "primary": "#75db92",
                      "inverse-primary": "#006d36",
                      "on-error": "#690005",
                      "on-tertiary": "#630b23",
                      "surface-tint": "#75db92",
                      "surface-container-lowest": "#0a0f0b",
                      "on-secondary-fixed-variant": "#42474b",
                      "secondary-container": "#42474b",
                      "on-secondary-fixed": "#171c20",
                      "surface-container-high": "#262b26",
                      "surface-variant": "#303630",
                      "secondary": "#c3c7cc",
                      "error": "#ffb4ab",
                      "primary-fixed": "#91f8ac",
                      "on-secondary-container": "#b1b6ba",
                      "on-background": "#dfe4dc",
                      "secondary-fixed": "#dfe3e8",
                      "on-secondary": "#2c3135",
                      "surface-container-highest": "#303630",
                      "surface-bright": "#353b35",
                      "on-tertiary-fixed-variant": "#812438",
                      "tertiary-fixed-dim": "#ffb2bb",
                      "background": "#0f1510",
                      "surface-dim": "#0f1510",
                      "surface-container": "#1b211c",
                      "outline-variant": "#3e4a3f",
                      "on-tertiary-container": "#59031c",
                      "primary-fixed-dim": "#75db92"
              },
              "borderRadius": {
                      "DEFAULT": "0.25rem",
                      "lg": "0.5rem",
                      "xl": "0.75rem",
                      "full": "9999px"
              },
              "spacing": {
                      "container-padding": "16px",
                      "lg": "24px",
                      "sm": "8px",
                      "md": "16px",
                      "base": "8px",
                      "xl": "32px",
                      "gutter": "12px",
                      "xs": "4px"
              },
              "fontFamily": {
                      "label-caps": ["Inter"],
                      "score-sub": ["JetBrains Mono"],
                      "body-sm": ["Inter"],
                      "h2": ["Inter"],
                      "h1": ["Inter"],
                      "body-md": ["Inter"],
                      "score-display": ["JetBrains Mono"]
              },
              "fontSize": {
                      "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                      "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                      "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                      "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                      "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                      "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                      "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
              }
            },
          },
        }
    </script>
<style>
        body { -webkit-tap-highlight-color: transparent; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-surface text-on-surface font-body-md overflow-hidden h-screen flex flex-col">
<!-- TopAppBar -->
<header class="bg-white dark:bg-slate-950 border-b border-slate-200 dark:border-slate-800 flex justify-between items-center w-full px-4 h-16 shrink-0 z-50">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-emerald-600 dark:text-emerald-500">sports_cricket</span>
<h1 class="font-sans tracking-tight font-bold text-on-surface">Team A vs Team B</h1>
<span class="bg-error text-on-error text-[10px] px-1.5 py-0.5 rounded-sm font-bold uppercase tracking-wider flex items-center gap-1">
<span class="w-1.5 h-1.5 bg-on-error rounded-full animate-pulse"></span>
                LIVE
            </span>
</div>
<div class="flex items-center gap-4">
<button class="hover:bg-slate-100 dark:hover:bg-slate-900 transition-all duration-200 ease-in-out p-2 rounded-full">
<span class="material-symbols-outlined text-slate-500 dark:text-slate-400">notifications</span>
</button>
<button class="hover:bg-slate-100 dark:hover:bg-slate-900 transition-all duration-200 ease-in-out p-2 rounded-full">
<span class="material-symbols-outlined text-slate-500 dark:text-slate-400">settings</span>
</button>
</div>
</header>
<main class="flex-1 overflow-y-auto p-md space-y-md">
<!-- Scoreboard Card -->
<section class="bg-surface-container border border-outline-variant p-md rounded-xl shadow-lg">
<div class="flex justify-between items-end">
<div>
<span class="text-label-caps font-label-caps text-on-surface-variant block mb-xs">TOTAL SCORE</span>
<div class="flex items-baseline gap-2">
<span class="text-score-display font-score-display text-primary">124/3</span>
<span class="text-score-sub font-score-sub text-on-surface-variant">15.2</span>
</div>
</div>
<div class="text-right">
<span class="text-label-caps font-label-caps text-on-surface-variant block mb-xs">CRR</span>
<span class="text-score-sub font-score-sub text-on-surface">8.12</span>
</div>
</div>
</section>
<!-- Player Stats - Bento Grid Style -->
<div class="grid grid-cols-2 gap-gutter">
<!-- Batsmen Panel -->
<div class="col-span-2 md:col-span-1 bg-surface-container-high border border-outline-variant rounded-xl p-md">
<h3 class="text-label-caps font-label-caps text-on-surface-variant mb-md flex items-center gap-2">
<span class="material-symbols-outlined text-[16px]">edit_note</span>
                    BATTING
                </h3>
<div class="space-y-sm">
<div class="flex justify-between items-center bg-surface-container-highest p-sm rounded-lg">
<div class="flex items-center gap-2">
<span class="text-primary material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">star</span>
<span class="font-bold text-on-surface">S. Gill</span>
</div>
<span class="font-score-sub text-on-surface">45<span class="text-xs text-on-surface-variant ml-1">(32)</span></span>
</div>
<div class="flex justify-between items-center p-sm opacity-70">
<div class="flex items-center gap-2">
<span class="w-3.5"></span>
<span class="text-on-surface">R. Pant</span>
</div>
<span class="font-score-sub text-on-surface">12<span class="text-xs text-on-surface-variant ml-1">(08)</span></span>
</div>
</div>
</div>
<!-- Bowler Panel -->
<div class="col-span-2 md:col-span-1 bg-surface-container-high border border-outline-variant rounded-xl p-md">
<h3 class="text-label-caps font-label-caps text-on-surface-variant mb-md flex items-center gap-2">
<span class="material-symbols-outlined text-[16px]">sports_baseball</span>
                    BOWLING
                </h3>
<div class="flex justify-between items-center bg-surface-container-highest p-sm rounded-lg">
<div>
<span class="font-bold text-on-surface block">M. Starc</span>
<div class="flex gap-1 mt-1">
<span class="w-2 h-2 rounded-full bg-primary"></span>
<span class="w-2 h-2 rounded-full bg-primary"></span>
<span class="w-2 h-2 rounded-full bg-on-surface-variant opacity-20"></span>
<span class="w-2 h-2 rounded-full bg-on-surface-variant opacity-20"></span>
<span class="w-2 h-2 rounded-full bg-on-surface-variant opacity-20"></span>
<span class="w-2 h-2 rounded-full bg-on-surface-variant opacity-20"></span>
</div>
</div>
<div class="text-right">
<span class="font-score-sub text-on-surface">3.2-24-1</span>
<span class="text-label-caps font-label-caps text-on-surface-variant block text-[10px]">ECON 7.2</span>
</div>
</div>
</div>
</div>
<!-- Scoring Grid -->
<section class="space-y-md">
<div class="grid grid-cols-4 gap-gutter">
<button class="aspect-square flex items-center justify-center rounded-full bg-surface-container-highest border border-outline-variant text-on-surface font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-md">0</button>
<button class="aspect-square flex items-center justify-center rounded-full bg-surface-container-highest border border-outline-variant text-on-surface font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-md">1</button>
<button class="aspect-square flex items-center justify-center rounded-full bg-surface-container-highest border border-outline-variant text-on-surface font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-md">2</button>
<button class="aspect-square flex items-center justify-center rounded-full bg-surface-container-highest border border-outline-variant text-on-surface font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-md">3</button>
<button class="aspect-square flex items-center justify-center rounded-full bg-primary text-on-primary font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-lg">4</button>
<button class="aspect-square flex items-center justify-center rounded-full bg-primary text-on-primary font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-lg">6</button>
<button class="aspect-square flex flex-col items-center justify-center rounded-full bg-error text-on-error font-score-display text-2xl active:scale-95 transition-transform duration-150 shadow-lg">
<span>W</span>
<span class="text-[10px] font-label-caps -mt-1">WICKET</span>
</button>
<button class="aspect-square flex items-center justify-center rounded-full bg-surface-container-highest border border-outline-variant text-on-surface-variant active:scale-95 transition-transform duration-150">
<span class="material-symbols-outlined">more_horiz</span>
</button>
</div>
<!-- Extras Panel -->
<div class="grid grid-cols-4 gap-sm">
<button class="py-sm bg-surface-container border border-outline-variant rounded-lg text-on-surface-variant font-label-caps hover:bg-surface-variant transition-colors">WD</button>
<button class="py-sm bg-surface-container border border-outline-variant rounded-lg text-on-surface-variant font-label-caps hover:bg-surface-variant transition-colors">NB</button>
<button class="py-sm bg-surface-container border border-outline-variant rounded-lg text-on-surface-variant font-label-caps hover:bg-surface-variant transition-colors">B</button>
<button class="py-sm bg-surface-container border border-outline-variant rounded-lg text-on-surface-variant font-label-caps hover:bg-surface-variant transition-colors">LB</button>
</div>
</section>
</main>
<!-- Bottom Control -->
<footer class="p-md bg-surface-dim border-t border-outline-variant shrink-0 z-50">
<button class="w-full py-4 bg-surface-container-high border border-outline-variant rounded-xl flex items-center justify-center gap-2 text-on-surface font-bold active:bg-secondary-container transition-colors shadow-inner">
<span class="material-symbols-outlined text-on-surface-variant">undo</span>
            Undo Last Ball
        </button>
</footer>
</body></html>

<!-- Profile -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0, viewport-fit=cover" name="viewport"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-container-low": "#171d18",
                    "inverse-on-surface": "#2c322c",
                    "on-primary-fixed": "#00210c",
                    "secondary-fixed-dim": "#c3c7cc",
                    "tertiary-container": "#df6d7f",
                    "tertiary-fixed": "#ffd9dc",
                    "primary-container": "#3ca360",
                    "inverse-surface": "#dfe4dc",
                    "on-surface": "#dfe4dc",
                    "on-error-container": "#ffdad6",
                    "surface": "#0f1510",
                    "on-primary-fixed-variant": "#005227",
                    "tertiary": "#ffb2bb",
                    "on-surface-variant": "#becabc",
                    "outline": "#889488",
                    "on-primary": "#003919",
                    "on-primary-container": "#003115",
                    "error-container": "#93000a",
                    "on-tertiary-fixed": "#400011",
                    "primary": "#75db92",
                    "inverse-primary": "#006d36",
                    "on-error": "#690005",
                    "on-tertiary": "#630b23",
                    "surface-tint": "#75db92",
                    "surface-container-lowest": "#0a0f0b",
                    "on-secondary-fixed-variant": "#42474b",
                    "secondary-container": "#42474b",
                    "on-secondary-fixed": "#171c20",
                    "surface-container-high": "#262b26",
                    "surface-variant": "#303630",
                    "secondary": "#c3c7cc",
                    "error": "#ffb4ab",
                    "primary-fixed": "#91f8ac",
                    "on-secondary-container": "#b1b6ba",
                    "on-background": "#dfe4dc",
                    "secondary-fixed": "#dfe3e8",
                    "on-secondary": "#2c3135",
                    "surface-container-highest": "#303630",
                    "surface-bright": "#353b35",
                    "on-tertiary-fixed-variant": "#812438",
                    "tertiary-fixed-dim": "#ffb2bb",
                    "background": "#0f1510",
                    "surface-dim": "#0f1510",
                    "surface-container": "#1b211c",
                    "outline-variant": "#3e4a3f",
                    "on-tertiary-container": "#59031c",
                    "primary-fixed-dim": "#75db92"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "container-padding": "16px",
                    "lg": "24px",
                    "sm": "8px",
                    "md": "16px",
                    "base": "8px",
                    "xl": "32px",
                    "gutter": "12px",
                    "xs": "4px"
            },
            "fontFamily": {
                    "label-caps": ["Inter"],
                    "score-sub": ["JetBrains Mono"],
                    "body-sm": ["Inter"],
                    "h2": ["Inter"],
                    "h1": ["Inter"],
                    "body-md": ["Inter"],
                    "score-display": ["JetBrains Mono"]
            },
            "fontSize": {
                    "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                    "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            background-color: #0c1821;
            color: #dfe4dc;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="flex flex-col min-h-screen">
<!-- TopAppBar -->
<header class="bg-white dark:bg-slate-950 border-b border-slate-200 dark:border-slate-800 docked full-width top-0 z-40">
<div class="flex justify-between items-center w-full px-4 h-16 max-w-5xl mx-auto">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-emerald-600 dark:text-emerald-500" data-icon="sports_cricket">sports_cricket</span>
<h1 class="font-sans tracking-tight font-bold text-xl font-black italic text-emerald-600 dark:text-emerald-500">inSwing</h1>
</div>
<div class="flex items-center gap-md">
<span class="material-symbols-outlined text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-900 transition-all duration-200 ease-in-out p-xs rounded-full" data-icon="notifications">notifications</span>
</div>
</div>
</header>
<main class="flex-grow container mx-auto px-container-padding pt-lg pb-xl max-w-5xl">
<!-- Profile Hero Section -->
<section class="relative rounded-xl overflow-hidden bg-surface-container mb-xl border border-outline-variant">
<div class="h-32 bg-gradient-to-r from-emerald-900 to-slate-900 opacity-40"></div>
<div class="px-md pb-md -mt-16 flex flex-col md:flex-row md:items-end gap-md">
<div class="relative inline-block">
<img class="w-32 h-32 rounded-xl border-4 border-surface object-cover shadow-xl" data-alt="A professional studio portrait of a charismatic Indian athlete with a focused gaze and a slight smile. The lighting is dramatic and low-key, emphasizing the contours of his face against a dark, moody background. The overall aesthetic is clean and high-end, matching a broadcast-quality sports profile. Subtle green atmospheric lighting touches the edges of his silhouette, reflecting a technical command center environment." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAWhApxsF5aGOz1B_x9UOOW0I7RKQIH4BQGWqn8XX0hwcFrA2WMBDouazcmNfSqnN7CEuqIHrm5_UTZUt3N7jI8jNMcD0ZY8b_Ub9-6jDh6nY-jaCQBnUxofoYvjEvLNv-9D_yTvQBT2ONy5EOUbNtgmtiwz3QnTPuBIpi_1JprZUGrBC_12AmEq8z7PfSO_O1HH9yt4fR4KOCpjBRVKtDQE3s-Rwrl5UCOwNF4IT4T2hWOAeahA1XhgBIEkkFTSlw139S03MOmACA"/>
</div>
<div class="flex-grow pb-xs">
<h2 class="font-h1 text-h1 text-on-surface">Rohit Sharma</h2>
<div class="flex items-center gap-xs mt-xs">
<span class="font-score-sub text-body-sm text-outline px-sm py-1 bg-surface-container-low rounded border border-outline-variant">INS-R0H1T7</span>
<button class="flex items-center justify-center p-1 text-primary hover:text-primary-fixed transition-colors">
<span class="material-symbols-outlined text-[18px]" data-icon="content_copy">content_copy</span>
</button>
</div>
</div>
<div class="flex flex-wrap gap-sm mb-xs">
<span class="font-label-caps text-label-caps bg-primary-container text-on-primary-container px-md py-sm rounded-full flex items-center gap-xs">
<span class="material-symbols-outlined text-[16px]" data-icon="sports_cricket" style="font-variation-settings: 'FILL' 1;">sports_cricket</span>
                        Right Hand Bat
                    </span>
<span class="font-label-caps text-label-caps bg-secondary-container text-on-secondary-container px-md py-sm rounded-full flex items-center gap-xs">
<span class="material-symbols-outlined text-[16px]" data-icon="bolt" style="font-variation-settings: 'FILL' 1;">bolt</span>
                        Right Arm Fast
                    </span>
</div>
</div>
</section>
<div class="grid grid-cols-1 lg:grid-cols-3 gap-xl">
<!-- Career Stats Section -->
<section class="lg:col-span-2 space-y-md">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-primary" data-icon="analytics">analytics</span>
<h3 class="font-h2 text-h2 uppercase tracking-widest text-on-surface-variant">Career Stats</h3>
</div>
<div class="grid grid-cols-2 md:grid-cols-4 gap-md">
<div class="bg-surface-container p-md rounded-xl border border-outline-variant flex flex-col gap-xs">
<span class="font-label-caps text-label-caps text-outline uppercase">Total Runs</span>
<span class="font-score-display text-score-display text-primary">4,821</span>
</div>
<div class="bg-surface-container p-md rounded-xl border border-outline-variant flex flex-col gap-xs">
<span class="font-label-caps text-label-caps text-outline uppercase">Highest Score</span>
<span class="font-score-display text-score-display text-on-surface">148*</span>
</div>
<div class="bg-surface-container p-md rounded-xl border border-outline-variant flex flex-col gap-xs">
<span class="font-label-caps text-label-caps text-outline uppercase">Average</span>
<span class="font-score-display text-score-display text-on-surface">42.8</span>
</div>
<div class="bg-surface-container p-md rounded-xl border border-outline-variant flex flex-col gap-xs">
<span class="font-label-caps text-label-caps text-outline uppercase">Strike Rate</span>
<span class="font-score-display text-score-display text-on-surface">138.4</span>
</div>
</div>
<!-- Bento Style Secondary Stats -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-md">
<div class="bg-surface-container p-md rounded-xl border border-outline-variant">
<h4 class="font-label-caps text-label-caps text-outline mb-md uppercase">Batting Breakdown</h4>
<div class="space-y-sm">
<div class="flex justify-between items-center">
<span class="font-body-md text-on-surface-variant">4s / 6s</span>
<span class="font-score-sub text-on-surface">342 / 128</span>
</div>
<div class="w-full bg-surface-container-low h-1 rounded-full overflow-hidden">
<div class="bg-primary h-full w-[75%]"></div>
</div>
<div class="flex justify-between items-center">
<span class="font-body-md text-on-surface-variant">50s / 100s</span>
<span class="font-score-sub text-on-surface">24 / 5</span>
</div>
<div class="w-full bg-surface-container-low h-1 rounded-full overflow-hidden">
<div class="bg-primary-container h-full w-[40%]"></div>
</div>
</div>
</div>
<div class="bg-surface-container p-md rounded-xl border border-outline-variant">
<h4 class="font-label-caps text-label-caps text-outline mb-md uppercase">Bowling Breakdown</h4>
<div class="space-y-sm">
<div class="flex justify-between items-center">
<span class="font-body-md text-on-surface-variant">Wickets</span>
<span class="font-score-sub text-on-surface">84</span>
</div>
<div class="flex justify-between items-center">
<span class="font-body-md text-on-surface-variant">Economy</span>
<span class="font-score-sub text-on-surface">7.24</span>
</div>
<div class="flex justify-between items-center">
<span class="font-body-md text-on-surface-variant">Best Figures</span>
<span class="font-score-sub text-on-surface">4/18</span>
</div>
</div>
</div>
</div>
</section>
<!-- Match History Section -->
<section class="space-y-md">
<div class="flex items-center justify-between">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-primary" data-icon="history">history</span>
<h3 class="font-h2 text-h2 uppercase tracking-widest text-on-surface-variant">History</h3>
</div>
<button class="text-primary font-label-caps text-label-caps hover:underline transition-all">VIEW ALL</button>
</div>
<div class="space-y-sm">
<!-- Performance Item -->
<div class="bg-surface-container p-md rounded-xl border border-outline-variant hover:border-primary transition-all duration-200">
<div class="flex justify-between mb-xs">
<span class="font-label-caps text-[10px] text-outline">VS TIGERS CC • 12 OCT</span>
<span class="font-label-caps text-[10px] text-emerald-500 bg-emerald-500/10 px-sm py-xs rounded">WON</span>
</div>
<div class="flex justify-between items-end">
<div>
<span class="font-score-sub text-h2 text-on-surface">64</span>
<span class="font-body-sm text-outline">(42)</span>
</div>
<div class="text-right">
<span class="font-body-sm text-on-surface-variant block">2/24</span>
<span class="font-label-caps text-[10px] text-outline">4.0 OVERS</span>
</div>
</div>
</div>
<!-- Performance Item -->
<div class="bg-surface-container p-md rounded-xl border border-outline-variant hover:border-primary transition-all duration-200">
<div class="flex justify-between mb-xs">
<span class="font-label-caps text-[10px] text-outline">VS ELEPHANTS XI • 08 OCT</span>
<span class="font-label-caps text-[10px] text-error bg-error/10 px-sm py-xs rounded">LOST</span>
</div>
<div class="flex justify-between items-end">
<div>
<span class="font-score-sub text-h2 text-on-surface">12</span>
<span class="font-body-sm text-outline">(8)</span>
</div>
<div class="text-right">
<span class="font-body-sm text-on-surface-variant block">0/32</span>
<span class="font-label-caps text-[10px] text-outline">3.0 OVERS</span>
</div>
</div>
</div>
<!-- Performance Item -->
<div class="bg-surface-container p-md rounded-xl border border-outline-variant hover:border-primary transition-all duration-200">
<div class="flex justify-between mb-xs">
<span class="font-label-caps text-[10px] text-outline">VS RAIDERS XI • 05 OCT</span>
<span class="font-label-caps text-[10px] text-emerald-500 bg-emerald-500/10 px-sm py-xs rounded">WON</span>
</div>
<div class="flex justify-between items-end">
<div>
<span class="font-score-sub text-h2 text-on-surface">104*</span>
<span class="font-body-sm text-outline">(56)</span>
</div>
<div class="text-right">
<span class="font-body-sm text-on-surface-variant block">1/14</span>
<span class="font-label-caps text-[10px] text-outline">2.0 OVERS</span>
</div>
</div>
</div>
</div>
</section>
</div>
</main>
<!-- BottomNavBar -->
<nav class="bg-white dark:bg-slate-950 border-t border-slate-200 dark:border-slate-800 shadow-lg dark:shadow-none fixed bottom-0 left-0 w-full h-20 pb-safe px-2 z-50">
<div class="flex justify-around items-center h-full max-w-5xl mx-auto">
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors active:scale-95 duration-150" href="#">
<span class="material-symbols-outlined" data-icon="home">home</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Home</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors active:scale-95 duration-150" href="#">
<span class="material-symbols-outlined" data-icon="sports_cricket">sports_cricket</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Matches</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors active:scale-95 duration-150" href="#">
<span class="material-symbols-outlined text-primary text-3xl" data-icon="add_circle" style="font-variation-settings: 'FILL' 1;">add_circle</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">New Match</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors active:scale-95 duration-150" href="#">
<span class="material-symbols-outlined" data-icon="group">group</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Connections</span>
</a>
<a class="flex flex-col items-center justify-center text-emerald-600 dark:text-emerald-500 scale-110 active:scale-95 duration-150" href="#">
<span class="material-symbols-outlined" data-icon="person" style="font-variation-settings: 'FILL' 1;">person</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Profile</span>
</a>
</div>
</nav>
<!-- Spacer for navigation -->
<div class="h-20"></div>
</body></html>


<!-- Register Form -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-tint": "#75db92",
                    "surface-container-lowest": "#0a0f0b",
                    "secondary-container": "#42474b",
                    "on-secondary-fixed": "#171c20",
                    "on-secondary-fixed-variant": "#42474b",
                    "primary": "#75db92",
                    "on-tertiary-fixed": "#400011",
                    "on-tertiary": "#630b23",
                    "on-error": "#690005",
                    "inverse-primary": "#006d36",
                    "tertiary": "#ffb2bb",
                    "outline": "#889488",
                    "on-surface-variant": "#becabc",
                    "on-primary": "#003919",
                    "error-container": "#93000a",
                    "on-primary-container": "#003115",
                    "on-primary-fixed-variant": "#005227",
                    "surface": "#0f1510",
                    "tertiary-fixed": "#ffd9dc",
                    "tertiary-container": "#df6d7f",
                    "secondary-fixed-dim": "#c3c7cc",
                    "on-error-container": "#ffdad6",
                    "primary-container": "#3ca360",
                    "on-surface": "#dfe4dc",
                    "inverse-surface": "#dfe4dc",
                    "on-primary-fixed": "#00210c",
                    "inverse-on-surface": "#2c322c",
                    "surface-container-low": "#171d18",
                    "outline-variant": "#3e4a3f",
                    "primary-fixed-dim": "#75db92",
                    "on-tertiary-container": "#59031c",
                    "surface-container": "#1b211c",
                    "tertiary-fixed-dim": "#ffb2bb",
                    "background": "#0f1510",
                    "surface-dim": "#0f1510",
                    "surface-bright": "#353b35",
                    "on-tertiary-fixed-variant": "#812438",
                    "secondary-fixed": "#dfe3e8",
                    "surface-container-highest": "#303630",
                    "on-secondary": "#2c3135",
                    "on-background": "#dfe4dc",
                    "primary-fixed": "#91f8ac",
                    "on-secondary-container": "#b1b6ba",
                    "secondary": "#c3c7cc",
                    "error": "#ffb4ab",
                    "surface-variant": "#303630",
                    "surface-container-high": "#262b26"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "container-padding": "16px",
                    "sm": "8px",
                    "lg": "24px",
                    "gutter": "12px",
                    "xs": "4px",
                    "xl": "32px",
                    "md": "16px",
                    "base": "8px"
            },
            "fontFamily": {
                    "label-caps": ["Inter"],
                    "score-sub": ["JetBrains Mono"],
                    "h2": ["Inter"],
                    "body-sm": ["Inter"],
                    "h1": ["Inter"],
                    "body-md": ["Inter"],
                    "score-display": ["JetBrains Mono"]
            },
            "fontSize": {
                    "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                    "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
        body { background-color: #0C1821; color: #dfe4dc; -webkit-font-smoothing: antialiased; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .broadcast-mesh {
            background-image: radial-gradient(#1E2D3D 0.5px, transparent 0.5px);
            background-size: 24px 24px;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="broadcast-mesh min-h-screen pb-24">
<!-- TopAppBar -->
<header class="bg-white dark:bg-slate-950 border-b border-slate-200 dark:border-slate-800 flex justify-between items-center w-full px-4 h-16 sticky top-0 z-40 transition-all duration-200 ease-in-out">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-emerald-600 dark:text-emerald-500" data-icon="sports_cricket">sports_cricket</span>
<h1 class="text-emerald-600 dark:text-emerald-500 text-xl font-black italic font-sans tracking-tight">inSwing</h1>
</div>
<button class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-slate-100 dark:hover:bg-slate-900 transition-all">
<span class="material-symbols-outlined text-slate-500 dark:text-slate-400" data-icon="notifications">notifications</span>
</button>
</header>
<main class="px-4 py-6 space-y-6 max-w-2xl mx-auto">
<!-- Search Bar -->
<div class="relative">
<span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline" data-icon="search">search</span>
<input class="w-full h-12 bg-surface-container-high border border-outline-variant rounded-xl pl-12 pr-4 text-on-surface focus:outline-none focus:ring-2 focus:ring-primary/30 transition-all placeholder:text-outline/50" placeholder="Search athletes by name or ID..." type="text"/>
</div>
<!-- Tab Pills -->
<div class="flex gap-2 overflow-x-auto pb-2 no-scrollbar">
<button class="bg-primary/10 text-primary px-4 py-2 rounded-full font-label-caps text-label-caps border border-primary/20 whitespace-nowrap">My Connections</button>
<button class="bg-surface-container-highest text-on-surface-variant px-4 py-2 rounded-full font-label-caps text-label-caps border border-outline-variant whitespace-nowrap flex items-center gap-2">
                Requests
                <span class="bg-error text-on-error w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold">2</span>
</button>
<button class="bg-surface-container-highest text-on-surface-variant px-4 py-2 rounded-full font-label-caps text-label-caps border border-outline-variant whitespace-nowrap">Discover</button>
</div>
<!-- Connection Cards List -->
<div class="space-y-3">
<!-- Card 1 -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md flex items-center justify-between hover:bg-surface-container-high transition-colors">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center border border-primary/30">
<span class="font-h2 text-primary">KL</span>
</div>
<div>
<h3 class="font-h2 text-body-md text-on-surface">KL Rahul</h3>
<p class="font-score-sub text-[12px] text-outline">INS-662391</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">RHB · Wicketkeeper · 158 matches</p>
</div>
</div>
<button class="px-4 py-1.5 rounded-lg border border-outline-variant text-outline font-label-caps text-label-caps">Connected ✓</button>
</div>
<!-- Card 2 -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md flex items-center justify-between hover:bg-surface-container-high transition-colors">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-tertiary-container/20 flex items-center justify-center border border-tertiary-container/30">
<span class="font-h2 text-tertiary">HP</span>
</div>
<div>
<h3 class="font-h2 text-body-md text-on-surface">Hardik Pandya</h3>
<p class="font-score-sub text-[12px] text-outline">INS-990212</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">RHB · Fast · 102 matches</p>
</div>
</div>
<button class="px-4 py-1.5 rounded-lg border border-primary text-primary font-label-caps text-label-caps bg-primary/5">Invite</button>
</div>
<!-- Card 3 -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md flex items-center justify-between hover:bg-surface-container-high transition-colors">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center border border-outline-variant">
<span class="font-h2 text-on-surface">JB</span>
</div>
<div>
<h3 class="font-h2 text-body-md text-on-surface">Jasprit Bumrah</h3>
<p class="font-score-sub text-[12px] text-outline">INS-443210</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">RHB · Fast · 89 matches</p>
</div>
</div>
<button class="px-4 py-1.5 rounded-lg border border-outline-variant text-outline font-label-caps text-label-caps">Connected ✓</button>
</div>
<!-- Card 4 -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md flex items-center justify-between hover:bg-surface-container-high transition-colors">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center border border-primary/30">
<span class="font-h2 text-primary">RP</span>
</div>
<div>
<h3 class="font-h2 text-body-md text-on-surface">Rishabh Pant</h3>
<p class="font-score-sub text-[12px] text-outline">INS-778841</p>
<p class="font-body-sm text-body-sm text-on-surface-variant">LHB · Wicketkeeper · 64 matches</p>
</div>
</div>
<button class="px-4 py-1.5 rounded-lg border border-primary text-primary font-label-caps text-label-caps bg-primary/5">Invite</button>
</div>
</div>
<!-- Visual Bento Hint -->
<div class="grid grid-cols-2 gap-3 mt-8">
<div class="col-span-1 h-32 rounded-xl bg-surface-container-low border border-outline-variant/30 flex flex-col justify-end p-4 relative overflow-hidden">
<div class="absolute top-2 right-2 opacity-10">
<span class="material-symbols-outlined text-4xl" data-icon="groups">groups</span>
</div>
<p class="font-label-caps text-[10px] text-outline uppercase">Active Peers</p>
<p class="font-h2 text-h1 text-primary">1.2k</p>
</div>
<div class="col-span-1 h-32 rounded-xl bg-surface-container-low border border-outline-variant/30 flex flex-col justify-end p-4 relative overflow-hidden">
<div class="absolute top-2 right-2 opacity-10">
<span class="material-symbols-outlined text-4xl" data-icon="military_tech">military_tech</span>
</div>
<p class="font-label-caps text-[10px] text-outline uppercase">Total Invites</p>
<p class="font-h2 text-h1 text-tertiary-container">48</p>
</div>
<div class="col-span-2 h-48 rounded-xl relative overflow-hidden border border-outline-variant/30 group">
<img class="w-full h-full object-cover grayscale opacity-40 group-hover:grayscale-0 group-hover:opacity-100 transition-all duration-500" data-alt="A cinematic low-angle shot of a group of diverse cricket players standing together in a professional stadium at sunset. The lighting is golden and high-contrast, casting long shadows across the green pitch. The aesthetic is modern and intense, reflecting a broadcast-quality sports environment with vibrant emerald and deep charcoal tones." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAczb8mRUaBjuLlmfGqLkik2POLHzLbnzYxjJuM-vn4uOi0qT_nEpGFrORB_ZMCRRrm3oCEjBBUIPo85XSqRRENWsq6pNYHSdETQVqcc86GoIPh8ZJ_QW31VApDRfIwKz8ZZrTS1atvuc9vFeoN3JaHFbtqMmCeVimDN2RCXK-arofPST8bQqwOFAz8XqJaMy1x3sgb9BQhi81FJoD_Yj5u-besqzod0okFa9-8-FdHFkYsSUiNkK0PdKcujiFnBAwatcBjKAzU-sE"/>
<div class="absolute inset-0 bg-gradient-to-t from-background to-transparent pointer-events-none"></div>
<div class="absolute bottom-4 left-4">
<h4 class="font-h2 text-body-md text-white">Find local clubs</h4>
<p class="font-body-sm text-body-sm text-outline">Expand your network across the city</p>
</div>
</div>
</div>
</main>
<!-- BottomNavBar -->
<nav class="bg-white dark:bg-slate-950 border-t border-slate-200 dark:border-slate-800 shadow-lg dark:shadow-none fixed bottom-0 left-0 w-full flex justify-around items-center h-20 pb-safe px-2 z-50">
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="home">home</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Home</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="sports_cricket">sports_cricket</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Matches</span>
</a>
<div class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150 -mt-6">
<div class="w-14 h-14 bg-emerald-600 rounded-full flex items-center justify-center shadow-lg shadow-emerald-900/40 text-white">
<span class="material-symbols-outlined scale-125" data-icon="add_circle" style="font-variation-settings: 'FILL' 1;">add_circle</span>
</div>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">New Match</span>
</div>
<a class="flex flex-col items-center justify-center text-emerald-600 dark:text-emerald-500 scale-110 duration-150" href="#">
<span class="material-symbols-outlined" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Connections</span>
</a>
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150" href="#">
<span class="material-symbols-outlined" data-icon="person">person</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Profile</span>
</a>
</nav>
</body></html>

<!-- Connections -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-tint": "#75db92",
                    "surface-container-lowest": "#0a0f0b",
                    "secondary-container": "#42474b",
                    "on-secondary-fixed": "#171c20",
                    "on-secondary-fixed-variant": "#42474b",
                    "primary": "#75db92",
                    "on-tertiary-fixed": "#400011",
                    "on-tertiary": "#630b23",
                    "on-error": "#690005",
                    "inverse-primary": "#006d36",
                    "tertiary": "#ffb2bb",
                    "outline": "#889488",
                    "on-surface-variant": "#becabc",
                    "on-primary": "#003919",
                    "error-container": "#93000a",
                    "on-primary-container": "#003115",
                    "on-primary-fixed-variant": "#005227",
                    "surface": "#0f1510",
                    "tertiary-fixed": "#ffd9dc",
                    "tertiary-container": "#df6d7f",
                    "secondary-fixed-dim": "#c3c7cc",
                    "on-error-container": "#ffdad6",
                    "primary-container": "#3ca360",
                    "on-surface": "#dfe4dc",
                    "inverse-surface": "#dfe4dc",
                    "on-primary-fixed": "#00210c",
                    "inverse-on-surface": "#2c322c",
                    "surface-container-low": "#171d18",
                    "outline-variant": "#3e4a3f",
                    "primary-fixed-dim": "#75db92",
                    "on-tertiary-container": "#59031c",
                    "surface-container": "#1b211c",
                    "tertiary-fixed-dim": "#ffb2bb",
                    "background": "#0c1821",
                    "surface-dim": "#0f1510",
                    "surface-bright": "#353b35",
                    "on-tertiary-fixed-variant": "#812438",
                    "secondary-fixed": "#dfe3e8",
                    "surface-container-highest": "#303630",
                    "on-secondary": "#2c3135",
                    "on-background": "#dfe4dc",
                    "primary-fixed": "#91f8ac",
                    "on-secondary-container": "#b1b6ba",
                    "secondary": "#c3c7cc",
                    "error": "#ffb4ab",
                    "surface-variant": "#303630",
                    "surface-container-high": "#262b26"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "container-padding": "16px",
                    "sm": "8px",
                    "lg": "24px",
                    "gutter": "12px",
                    "xs": "4px",
                    "xl": "32px",
                    "md": "16px",
                    "base": "8px"
            },
            "fontFamily": {
                    "label-caps": ["Inter"],
                    "score-sub": ["JetBrains Mono"],
                    "h2": ["Inter"],
                    "body-sm": ["Inter"],
                    "h1": ["Inter"],
                    "body-md": ["Inter"],
                    "score-display": ["JetBrains Mono"]
            },
            "fontSize": {
                    "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                    "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
        body {
            background-color: #0c1821;
            background-image: radial-gradient(#1e2d3d 0.5px, transparent 0.5px);
            background-size: 24px 24px;
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .unread-border {
            border-left: 3px solid #1B8A4A;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="text-on-background min-h-screen flex flex-col font-body-md">
<!-- TopAppBar -->
<header class="bg-white dark:bg-slate-950 border-b border-slate-200 dark:border-slate-800 docked full-width top-0 z-50">
<div class="flex justify-between items-center w-full px-4 h-16 max-w-7xl mx-auto">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-emerald-600 dark:text-emerald-500" data-icon="sports_cricket">sports_cricket</span>
<span class="text-xl font-black italic text-emerald-600 dark:text-emerald-500 font-sans tracking-tight">inSwing</span>
</div>
<div class="flex items-center gap-4">
<button class="relative p-2 rounded-full hover:bg-slate-100 dark:hover:bg-slate-900 transition-all duration-200 ease-in-out text-emerald-600 dark:text-emerald-500">
<span class="material-symbols-outlined" data-icon="notifications" style="font-variation-settings: 'FILL' 1;">notifications</span>
<span class="absolute top-2 right-2 w-2 h-2 bg-error rounded-full"></span>
</button>
</div>
</div>
</header>
<!-- Main Canvas -->
<main class="flex-1 w-full max-w-2xl mx-auto px-container-padding pt-lg pb-32">
<!-- Header Section -->
<div class="flex justify-between items-end mb-lg">
<h1 class="font-h1 text-h1 text-on-background">Notifications</h1>
<button class="font-label-caps text-label-caps text-on-secondary-container hover:text-primary transition-colors mb-1">
                Mark all read
            </button>
</div>
<!-- Notification List -->
<div class="space-y-md">
<!-- Item 1: Match Invite (Unread) -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md unread-border shadow-sm flex gap-md">
<div class="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">
<span class="material-symbols-outlined text-primary" data-icon="sports_cricket" style="font-variation-settings: 'FILL' 1;">sports_cricket</span>
</div>
<div class="flex-1 space-y-sm">
<div class="flex justify-between items-start">
<p class="font-body-md text-on-surface"><span class="font-bold">Rohit</span> invited you to a <span class="text-primary font-bold">T10 match</span></p>
<span class="font-score-sub text-[10px] text-on-secondary-container uppercase">2h ago</span>
</div>
<div class="flex gap-sm pt-xs">
<button class="bg-[#1B8A4A] text-on-primary px-lg py-sm rounded-lg font-label-caps text-label-caps hover:brightness-110 transition-all">Accept</button>
<button class="border border-outline-variant text-on-surface px-lg py-sm rounded-lg font-label-caps text-label-caps hover:bg-surface-container-high transition-all">Decline</button>
</div>
</div>
</div>
<!-- Item 2: Friend Request (Unread) -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md unread-border shadow-sm flex gap-md">
<div class="w-10 h-10 rounded-full bg-blue-500/20 flex items-center justify-center flex-shrink-0">
<span class="material-symbols-outlined text-blue-400" data-icon="person_add" style="font-variation-settings: 'FILL' 1;">person_add</span>
</div>
<div class="flex-1 space-y-sm">
<div class="flex justify-between items-start">
<p class="font-body-md text-on-surface"><span class="font-bold">Virat</span> wants to connect with you</p>
<span class="font-score-sub text-[10px] text-on-secondary-container uppercase">4h ago</span>
</div>
<div class="flex gap-sm pt-xs">
<button class="bg-[#1B8A4A] text-on-primary px-lg py-sm rounded-lg font-label-caps text-label-caps hover:brightness-110 transition-all">Accept</button>
<button class="border border-outline-variant text-on-surface px-lg py-sm rounded-lg font-label-caps text-label-caps hover:bg-surface-container-high transition-all">Decline</button>
</div>
</div>
</div>
<!-- Item 3: Match Update -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md shadow-sm flex gap-md opacity-90">
<div class="w-10 h-10 rounded-full bg-emerald-500/20 flex items-center justify-center flex-shrink-0">
<span class="material-symbols-outlined text-emerald-400" data-icon="emoji_events" style="font-variation-settings: 'FILL' 1;">emoji_events</span>
</div>
<div class="flex-1 space-y-sm">
<div class="flex justify-between items-start">
<div>
<p class="font-body-md text-on-surface font-bold">Warriors vs Titans</p>
<p class="font-body-sm text-on-secondary-container">Match finished. You won!</p>
</div>
<span class="font-score-sub text-[10px] text-on-secondary-container uppercase">6h ago</span>
</div>
</div>
</div>
<!-- Item 4: Rules Proposed -->
<div class="bg-surface-container border border-outline-variant rounded-xl p-md shadow-sm flex gap-md opacity-90">
<div class="w-10 h-10 rounded-full bg-amber-500/20 flex items-center justify-center flex-shrink-0">
<span class="material-symbols-outlined text-amber-400" data-icon="gavel" style="font-variation-settings: 'FILL' 1;">gavel</span>
</div>
<div class="flex-1 space-y-sm">
<div class="flex justify-between items-start">
<p class="font-body-md text-on-surface">Opponent proposed <span class="text-amber-400">custom rules</span> for your next match</p>
<span class="font-score-sub text-[10px] text-on-secondary-container uppercase">1d ago</span>
</div>
<div class="pt-xs">
<button class="border border-outline-variant text-on-surface px-lg py-sm rounded-lg font-label-caps text-label-caps hover:bg-surface-container-high transition-all">View Rules</button>
</div>
</div>
</div>
<!-- Empty State / Visual Polish -->
<div class="pt-xl text-center">
<p class="font-label-caps text-on-secondary-container text-xs opacity-50">End of recent updates</p>
</div>
</div>
</main>
<!-- BottomNavBar -->
<nav class="bg-white dark:bg-slate-950 border-t border-slate-200 dark:border-slate-800 fixed bottom-0 left-0 w-full flex justify-around items-center h-20 pb-safe px-2 z-50 shadow-lg dark:shadow-none">
<!-- Home -->
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150 active:scale-95" href="#">
<span class="material-symbols-outlined" data-icon="home">home</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Home</span>
</a>
<!-- Matches -->
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150 active:scale-95" href="#">
<span class="material-symbols-outlined" data-icon="sports_cricket">sports_cricket</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Matches</span>
</a>
<!-- New Match -->
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150 active:scale-95" href="#">
<span class="material-symbols-outlined text-3xl" data-icon="add_circle">add_circle</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">New Match</span>
</a>
<!-- Connections -->
<a class="flex flex-col items-center justify-center text-slate-500 dark:text-slate-400 opacity-70 hover:text-emerald-400 transition-colors duration-150 active:scale-95" href="#">
<span class="material-symbols-outlined" data-icon="group">group</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Connections</span>
</a>
<!-- Profile (Active context for Inbox/Self) -->
<a class="flex flex-col items-center justify-center text-emerald-600 dark:text-emerald-500 scale-110 duration-150 active:scale-95" href="#">
<span class="material-symbols-outlined" data-icon="person" style="font-variation-settings: 'FILL' 1;">person</span>
<span class="font-sans text-[10px] uppercase font-bold tracking-widest mt-1">Profile</span>
</a>
</nav>
</body></html>

<!-- Login Form -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-variant": "#303630",
                    "inverse-on-surface": "#2c322c",
                    "on-error": "#690005",
                    "on-surface-variant": "#becabc",
                    "on-secondary": "#2c3135",
                    "secondary-container": "#42474b",
                    "surface-tint": "#75db92",
                    "surface-container-highest": "#303630",
                    "background": "#0f1510",
                    "tertiary-fixed": "#ffd9dc",
                    "tertiary-container": "#df6d7f",
                    "surface-bright": "#353b35",
                    "on-primary-container": "#003115",
                    "secondary-fixed": "#dfe3e8",
                    "outline-variant": "#3e4a3f",
                    "secondary-fixed-dim": "#c3c7cc",
                    "error": "#ffb4ab",
                    "error-container": "#93000a",
                    "primary-container": "#3ca360",
                    "on-surface": "#dfe4dc",
                    "surface-container-low": "#171d18",
                    "on-secondary-container": "#b1b6ba",
                    "secondary": "#c3c7cc",
                    "on-primary": "#003919",
                    "primary-fixed": "#91f8ac",
                    "on-tertiary-fixed-variant": "#812438",
                    "on-error-container": "#ffdad6",
                    "surface": "#0f1510",
                    "on-secondary-fixed-variant": "#42474b",
                    "primary-fixed-dim": "#75db92",
                    "outline": "#889488",
                    "surface-container": "#1b211c",
                    "on-secondary-fixed": "#171c20",
                    "inverse-surface": "#dfe4dc",
                    "primary": "#75db92",
                    "surface-container-high": "#262b26",
                    "on-tertiary": "#630b23",
                    "surface-dim": "#0f1510",
                    "inverse-primary": "#006d36",
                    "on-primary-fixed": "#00210c",
                    "tertiary": "#ffb2bb",
                    "surface-container-lowest": "#0a0f0b",
                    "on-primary-fixed-variant": "#005227",
                    "on-background": "#dfe4dc",
                    "on-tertiary-container": "#59031c",
                    "tertiary-fixed-dim": "#ffb2bb",
                    "on-tertiary-fixed": "#400011"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "base": "8px",
                    "xs": "4px",
                    "gutter": "12px",
                    "xl": "32px",
                    "lg": "24px",
                    "container-padding": "16px",
                    "sm": "8px",
                    "md": "16px"
            },
            "fontFamily": {
                    "score-sub": ["JetBrains Mono"],
                    "body-md": ["Inter"],
                    "score-display": ["JetBrains Mono"],
                    "body-sm": ["Inter"],
                    "h1": ["Inter"],
                    "label-caps": ["Inter"],
                    "h2": ["Inter"]
            },
            "fontSize": {
                    "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
        body {
            background-color: #0C1821;
            background-image: radial-gradient(#1E2D3D 1px, transparent 1px);
            background-size: 24px 24px;
        }
        .glass-panel {
            background: rgba(22, 32, 41, 0.8);
            backdrop-filter: blur(8px);
            border: 1px solid #2A3A4A;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="min-h-screen text-on-background font-body-md selection:bg-primary selection:text-on-primary">
<!-- Top AppBar (Transactional - No Bottom Nav) -->
<header class="fixed top-0 left-0 w-full z-50 flex justify-between items-center px-4 h-14 bg-slate-950 border-b border-slate-800">
<div class="flex items-center gap-3">
<button class="flex items-center justify-center w-10 h-10 rounded-full hover:bg-slate-900 transition-colors active:opacity-80">
<span class="material-symbols-outlined text-slate-400">arrow_back</span>
</button>
<h2 class="font-h2 text-h2 text-on-surface">New Match</h2>
</div>
<div class="px-3 py-1 rounded-full border border-outline-variant text-label-caps font-label-caps text-on-surface-variant">
            1/3
        </div>
</header>
<main class="pt-24 pb-32 px-container-padding max-w-lg mx-auto">
<!-- Hero Header -->
<div class="mb-xl">
<h1 class="font-h1 text-h1 mb-xs">Choose Match Type</h1>
<p class="font-body-sm text-body-sm text-on-surface-variant">How will this match be managed?</p>
</div>
<!-- Selection Options -->
<div class="space-y-md">
<!-- Card 1: Selected State -->
<label class="relative block cursor-pointer group">
<input checked="" class="sr-only" name="match_type" type="radio"/>
<div class="p-lg rounded-xl border-2 transition-all duration-200 bg-[#1b211c] border-primary-container ring-1 ring-primary/20">
<div class="flex items-start gap-md">
<div class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
<span class="material-symbols-outlined text-primary" data-weight="fill">bolt</span>
</div>
<div class="pr-8">
<h3 class="font-h2 text-h2 mb-1">Quick Match</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant">You score everything. Perfect for casual games.</p>
</div>
</div>
<!-- Selected Checkmark -->
<div class="absolute top-4 right-4">
<span class="material-symbols-outlined text-primary">check_circle</span>
</div>
</div>
</label>
<!-- Card 2: Default State -->
<label class="relative block cursor-pointer group">
<input class="sr-only" name="match_type" type="radio"/>
<div class="p-lg rounded-xl border border-outline-variant transition-all duration-200 bg-[#1b211c] hover:border-outline">
<div class="flex items-start gap-md">
<div class="w-12 h-12 rounded-full bg-surface-container-highest flex items-center justify-center shrink-0">
<span class="material-symbols-outlined text-on-surface-variant">group</span>
</div>
<div>
<div class="flex items-center gap-xs mb-1">
<h3 class="font-h2 text-h2">Dual Captain</h3>
<span class="bg-primary-container/20 text-primary px-1.5 py-0.5 rounded text-[10px] font-bold tracking-tighter uppercase">COMPETITIVE</span>
</div>
<p class="font-body-sm text-body-sm text-on-surface-variant">Invite opponent captain. Both manage teams in real-time.</p>
</div>
</div>
</div>
</label>
<!-- Visual Context Illustration (Bento-like hint) -->
<div class="grid grid-cols-2 gap-md pt-lg">
<div class="h-32 rounded-xl bg-surface-container-low border border-outline-variant overflow-hidden relative">
<img class="w-full h-full object-cover opacity-40 mix-blend-luminosity" data-alt="A professional cricket player in white kit preparing for a shot under stadium lights. The scene is shot with high contrast and deep shadows, reflecting a professional broadcast aesthetic with emerald green accents. The atmosphere is tense and focused, emphasizing precision and performance." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCPjdLqBaOJUpti_kauQ_-OUGucLLClo4I4Mzq_oVdx5SSPIIygK0YMaQplm-G-8WjXX30KDdUrN8CiXqzY77FiUC_NADg4tu9krvqon90MdWRCLjl1KkInuxt1fnCWM2HdoHEqSjTUQL3CNzhahxnSfHPI8uoVz_T6BGnfOVnTPsHmQazensCP0uVKRTIdmp7cuYBm813cBFmNEN9S-Q_heyFYxQu3mAeHLZJHl-P-Rli0lSTKSn7MRi4-Z0T77tfQrEX2czV3LjA"/>
<div class="absolute inset-0 bg-gradient-to-t from-surface-container-low to-transparent"></div>
<div class="absolute bottom-2 left-2 flex items-center gap-1">
<span class="w-2 h-2 rounded-full bg-primary"></span>
<span class="text-[10px] font-bold text-on-surface uppercase tracking-widest">Score Real-time</span>
</div>
</div>
<div class="h-32 rounded-xl bg-surface-container-low border border-outline-variant flex flex-col justify-center items-center p-md text-center">
<span class="material-symbols-outlined text-primary mb-2 text-3xl">analytics</span>
<span class="text-[10px] font-bold text-on-surface-variant uppercase tracking-widest leading-tight">Advanced Stats Ready</span>
</div>
</div>
</div>
</main>
<!-- Fixed Bottom Action -->
<footer class="fixed bottom-0 left-0 w-full p-container-padding bg-slate-950/80 backdrop-blur-xl border-t border-slate-800 z-50">
<div class="max-w-lg mx-auto">
<button class="w-full h-14 bg-[#1B8A4A] text-on-primary rounded-lg font-h2 text-h2 flex items-center justify-center gap-2 active:scale-[0.98] transition-transform shadow-lg shadow-primary/10">
                Continue
                <span class="material-symbols-outlined">arrow_forward</span>
</button>
</div>
</footer>
</body></html>

<!-- Notifications -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<style>
        body {
            background-color: #0c1821;
            background-image: radial-gradient(#2a3a4a 0.5px, transparent 0.5px);
            background-size: 16px 16px;
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
    </style>
<script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "surface-variant": "#303630",
                      "inverse-on-surface": "#2c322c",
                      "on-error": "#690005",
                      "on-surface-variant": "#becabc",
                      "on-secondary": "#2c3135",
                      "secondary-container": "#42474b",
                      "surface-tint": "#75db92",
                      "surface-container-highest": "#303630",
                      "background": "#0f1510",
                      "tertiary-fixed": "#ffd9dc",
                      "tertiary-container": "#df6d7f",
                      "surface-bright": "#353b35",
                      "on-primary-container": "#003115",
                      "secondary-fixed": "#dfe3e8",
                      "outline-variant": "#3e4a3f",
                      "secondary-fixed-dim": "#c3c7cc",
                      "error": "#ffb4ab",
                      "error-container": "#93000a",
                      "primary-container": "#3ca360",
                      "on-surface": "#dfe4dc",
                      "surface-container-low": "#171d18",
                      "on-secondary-container": "#b1b6ba",
                      "secondary": "#c3c7cc",
                      "on-primary": "#003919",
                      "primary-fixed": "#91f8ac",
                      "on-tertiary-fixed-variant": "#812438",
                      "on-error-container": "#ffdad6",
                      "surface": "#0f1510",
                      "on-secondary-fixed-variant": "#42474b",
                      "primary-fixed-dim": "#75db92",
                      "outline": "#889488",
                      "surface-container": "#1b211c",
                      "on-secondary-fixed": "#171c20",
                      "inverse-surface": "#dfe4dc",
                      "primary": "#75db92",
                      "surface-container-high": "#262b26",
                      "on-tertiary": "#630b23",
                      "surface-dim": "#0f1510",
                      "inverse-primary": "#006d36",
                      "on-primary-fixed": "#00210c",
                      "tertiary": "#ffb2bb",
                      "surface-container-lowest": "#0a0f0b",
                      "on-primary-fixed-variant": "#005227",
                      "on-background": "#dfe4dc",
                      "on-tertiary-container": "#59031c",
                      "tertiary-fixed-dim": "#ffb2bb",
                      "on-tertiary-fixed": "#400011"
              },
              "borderRadius": {
                      "DEFAULT": "0.25rem",
                      "lg": "0.5rem",
                      "xl": "0.75rem",
                      "full": "9999px"
              },
              "spacing": {
                      "base": "8px",
                      "xs": "4px",
                      "gutter": "12px",
                      "xl": "32px",
                      "lg": "24px",
                      "container-padding": "16px",
                      "sm": "8px",
                      "md": "16px"
              },
              "fontFamily": {
                      "score-sub": ["JetBrains Mono"],
                      "body-md": ["Inter"],
                      "score-display": ["JetBrains Mono"],
                      "body-sm": ["Inter"],
                      "h1": ["Inter"],
                      "label-caps": ["Inter"],
                      "h2": ["Inter"]
              },
              "fontSize": {
                      "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                      "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                      "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                      "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                      "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                      "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                      "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}]
              }
            },
          },
        }
      </script>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-surface text-on-surface font-body-md min-h-screen pb-32">
<!-- Top Bar Component -->
<header class="fixed top-0 left-0 w-full z-50 flex justify-between items-center px-4 h-14 bg-slate-950 border-b border-slate-800">
<div class="flex items-center gap-4">
<button class="flex items-center justify-center w-8 h-8 rounded-full hover:bg-slate-900 transition-colors">
<span class="material-symbols-outlined text-slate-400">arrow_back</span>
</button>
<h1 class="font-inter text-sm font-bold tracking-tight uppercase text-slate-400">MATCH RULES</h1>
</div>
<div class="bg-emerald-500/10 px-3 py-1 rounded-full">
<span class="text-emerald-500 font-inter text-[10px] font-extrabold tracking-widest uppercase">2/3</span>
</div>
</header>
<main class="pt-20 px-4 max-w-lg mx-auto space-y-6">
<!-- Preset Chips Row -->
<div class="flex gap-2 overflow-x-auto pb-2 scrollbar-hide no-scrollbar">
<button class="whitespace-nowrap px-4 py-2 rounded-lg bg-surface-container border border-outline-variant text-on-surface-variant font-label-caps text-xs transition-colors hover:bg-surface-container-high">Quick 6</button>
<button class="whitespace-nowrap px-4 py-2 rounded-lg bg-primary text-on-primary font-label-caps text-xs transition-colors shadow-lg shadow-primary/20">T10</button>
<button class="whitespace-nowrap px-4 py-2 rounded-lg bg-surface-container border border-outline-variant text-on-surface-variant font-label-caps text-xs transition-colors hover:bg-surface-container-high">T20</button>
<button class="whitespace-nowrap px-4 py-2 rounded-lg bg-surface-container border border-outline-variant text-on-surface-variant font-label-caps text-xs transition-colors hover:bg-surface-container-high">Custom</button>
</div>
<!-- Card 1: Overs & Format -->
<section class="bg-surface-container border border-outline-variant rounded-xl p-4 space-y-4">
<div class="flex items-center gap-2 mb-2">
<span class="material-symbols-outlined text-primary text-lg">format_list_numbered</span>
<h2 class="font-h2 text-h2">Overs &amp; Format</h2>
</div>
<div class="space-y-4">
<!-- Stepper Item -->
<div class="flex items-center justify-between py-2 border-b border-outline-variant/30">
<div>
<p class="font-body-md text-on-surface">Overs per side</p>
<p class="font-body-sm text-on-surface-variant text-xs">Standard T10 format</p>
</div>
<div class="flex items-center gap-4 bg-surface-container-highest rounded-lg p-1">
<button class="w-8 h-8 flex items-center justify-center rounded-md bg-surface-variant text-on-surface hover:bg-outline-variant transition-colors">
<span class="material-symbols-outlined text-sm">remove</span>
</button>
<span class="font-score-display text-lg w-8 text-center text-primary">10</span>
<button class="w-8 h-8 flex items-center justify-center rounded-md bg-surface-variant text-on-surface hover:bg-outline-variant transition-colors">
<span class="material-symbols-outlined text-sm">add</span>
</button>
</div>
</div>
<!-- Stepper Item -->
<div class="flex items-center justify-between py-2 border-b border-outline-variant/30">
<div>
<p class="font-body-md text-on-surface">Powerplay overs</p>
<p class="font-body-sm text-on-surface-variant text-xs">Initial fielding restrictions</p>
</div>
<div class="flex items-center gap-4 bg-surface-container-highest rounded-lg p-1">
<button class="w-8 h-8 flex items-center justify-center rounded-md bg-surface-variant text-on-surface hover:bg-outline-variant transition-colors">
<span class="material-symbols-outlined text-sm">remove</span>
</button>
<span class="font-score-display text-lg w-8 text-center text-primary">2</span>
<button class="w-8 h-8 flex items-center justify-center rounded-md bg-surface-variant text-on-surface hover:bg-outline-variant transition-colors">
<span class="material-symbols-outlined text-sm">add</span>
</button>
</div>
</div>
<!-- Stepper Item -->
<div class="flex items-center justify-between py-2">
<div>
<p class="font-body-md text-on-surface">Players per team</p>
<p class="font-body-sm text-on-surface-variant text-xs">Squad size</p>
</div>
<div class="flex items-center gap-4 bg-surface-container-highest rounded-lg p-1">
<button class="w-8 h-8 flex items-center justify-center rounded-md bg-surface-variant text-on-surface hover:bg-outline-variant transition-colors">
<span class="material-symbols-outlined text-sm">remove</span>
</button>
<span class="font-score-display text-lg w-8 text-center text-primary">6</span>
<button class="w-8 h-8 flex items-center justify-center rounded-md bg-surface-variant text-on-surface hover:bg-outline-variant transition-colors">
<span class="material-symbols-outlined text-sm">add</span>
</button>
</div>
</div>
</div>
</section>
<!-- Card 2: Special Rules -->
<section class="bg-surface-container border border-outline-variant rounded-xl p-4 space-y-4">
<div class="flex items-center gap-2 mb-2">
<span class="material-symbols-outlined text-primary text-lg">gavel</span>
<h2 class="font-h2 text-h2">Special Rules</h2>
</div>
<div class="space-y-3">
<!-- Toggle Item OFF -->
<div class="flex items-center justify-between">
<span class="font-body-md text-on-surface">Last Man Batting</span>
<button class="relative w-12 h-6 bg-surface-container-highest rounded-full transition-colors flex items-center px-1">
<div class="w-4 h-4 bg-on-surface-variant rounded-full transition-transform"></div>
</button>
</div>
<!-- Toggle Item ON -->
<div class="flex items-center justify-between">
<span class="font-body-md text-on-surface">Free Hit on No Ball</span>
<button class="relative w-12 h-6 bg-primary rounded-full transition-colors flex items-center justify-end px-1">
<div class="w-4 h-4 bg-on-primary rounded-full transition-transform"></div>
</button>
</div>
<!-- Toggle Item OFF -->
<div class="flex items-center justify-between">
<span class="font-body-md text-on-surface">Super Over (if tied)</span>
<button class="relative w-12 h-6 bg-surface-container-highest rounded-full transition-colors flex items-center px-1">
<div class="w-4 h-4 bg-on-surface-variant rounded-full transition-transform"></div>
</button>
</div>
</div>
</section>
<!-- Card 3: Scoring -->
<section class="bg-surface-container border border-outline-variant rounded-xl p-4 space-y-4">
<div class="flex items-center gap-2 mb-2">
<span class="material-symbols-outlined text-primary text-lg">sports_score</span>
<h2 class="font-h2 text-h2">Scoring Control</h2>
</div>
<div class="space-y-2">
<label class="font-label-caps text-on-surface-variant text-[10px]">WHO CAN SCORE?</label>
<div class="relative">
<div class="w-full bg-surface-container-highest border border-outline-variant rounded-lg p-3 flex items-center justify-between cursor-pointer">
<span class="font-body-md text-on-surface">Both Captains</span>
<span class="material-symbols-outlined text-on-surface-variant">expand_more</span>
</div>
</div>
</div>
</section>
<!-- Visual Anchor: Broadcast Equipment Style Card -->
<div class="relative w-full aspect-video rounded-xl overflow-hidden border border-outline-variant group">
<img class="w-full h-full object-cover opacity-60 group-hover:scale-105 transition-transform duration-700" data-alt="A cinematic, low-angle shot of a high-tech cricket broadcasting booth at night. The foreground features sleek glass monitors displaying glowing data visualizations of player statistics and match analytics in vibrant emerald green and cool slate tones. Soft, ambient stadium lighting filters in from large windows, creating a professional, command-center atmosphere. The overall aesthetic is clean, technical, and broadcast-ready with deep shadows and high-contrast highlights." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDTnb7r_5gpYCZaZYVkiK7R9jdiAMgAmVAYvGRTFIw31VzAXubKt0BIbPHtWf1a6GCMC05_nTdONoledffgkwWlyR22xPvhrUcOSNDO-8AF72vu0angMutt0Emu_7NGy5UVymQBuWpr4t9K_iPFPgdi6wYt0GQcDmaUzTQtpLFd2Z2JL-jt8ClS82_cnBhEVuJNs7-Ec7E0a2NT70H-MdGTb5J0njmQZaiGOjIWtnaMzsNffXs_RV-u66WknFRaw5aj6NzhUuIDiH8"/>
<div class="absolute inset-0 bg-gradient-to-t from-background via-transparent to-transparent"></div>
<div class="absolute bottom-4 left-4">
<div class="bg-red-600 text-white px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-widest flex items-center gap-1 mb-1">
<span class="w-1.5 h-1.5 bg-white rounded-full animate-pulse"></span>
                    Broadcast Ready
                </div>
<p class="font-label-caps text-on-surface text-sm">Rules auto-synced to live feed</p>
</div>
</div>
</main>
<!-- Bottom Action Button -->
<div class="fixed bottom-0 left-0 w-full p-4 bg-slate-950/80 backdrop-blur-md">
<button class="w-full h-14 bg-primary text-on-primary rounded-lg font-h2 flex items-center justify-center gap-2 active:scale-[0.98] transition-transform shadow-xl shadow-primary/20">
            CONTINUE
            <span class="material-symbols-outlined">chevron_right</span>
</button>
</div>
</body></html>

<!-- Profile Setup -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "error-container": "#93000a",
                        "on-primary-container": "#003115",
                        "primary-fixed-dim": "#75db92",
                        "secondary": "#c3c7cc",
                        "on-surface-variant": "#becabc",
                        "on-tertiary": "#630b23",
                        "surface-container-lowest": "#0a0f0b",
                        "surface-bright": "#353b35",
                        "outline": "#889488",
                        "tertiary-fixed": "#ffd9dc",
                        "secondary-fixed-dim": "#c3c7cc",
                        "on-error": "#690005",
                        "secondary-fixed": "#dfe3e8",
                        "on-primary-fixed": "#00210c",
                        "tertiary": "#ffb2bb",
                        "on-tertiary-fixed": "#400011",
                        "on-error-container": "#ffdad6",
                        "on-surface": "#dfe4dc",
                        "surface-tint": "#75db92",
                        "on-secondary-fixed-variant": "#42474b",
                        "on-tertiary-container": "#59031c",
                        "surface-container-highest": "#303630",
                        "surface-container-high": "#262b26",
                        "inverse-surface": "#dfe4dc",
                        "error": "#ffb4ab",
                        "tertiary-fixed-dim": "#ffb2bb",
                        "on-primary": "#003919",
                        "surface-variant": "#303630",
                        "inverse-primary": "#006d36",
                        "tertiary-container": "#df6d7f",
                        "on-secondary": "#2c3135",
                        "inverse-on-surface": "#2c322c",
                        "surface": "#0f1510",
                        "on-primary-fixed-variant": "#005227",
                        "on-background": "#dfe4dc",
                        "surface-container": "#1b211c",
                        "on-secondary-container": "#b1b6ba",
                        "on-tertiary-fixed-variant": "#812438",
                        "surface-dim": "#0f1510",
                        "secondary-container": "#42474b",
                        "primary-container": "#3ca360",
                        "outline-variant": "#3e4a3f",
                        "primary": "#75db92",
                        "on-secondary-fixed": "#171c20",
                        "surface-container-low": "#171d18",
                        "primary-fixed": "#91f8ac",
                        "background": "#0f1510"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "gutter": "12px",
                        "xl": "32px",
                        "lg": "24px",
                        "sm": "8px",
                        "md": "16px",
                        "base": "8px",
                        "xs": "4px",
                        "container-padding": "16px"
                    },
                    "fontFamily": {
                        "label-caps": ["Inter"],
                        "h1": ["Inter"],
                        "score-display": ["JetBrains Mono"],
                        "h2": ["Inter"],
                        "score-sub": ["JetBrains Mono"],
                        "body-md": ["Inter"],
                        "body-sm": ["Inter"]
                    },
                    "fontSize": {
                        "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                        "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                        "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}]
                    }
                },
            },
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body { background-color: #0C1821; }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="text-on-background font-body-md antialiased min-h-screen flex flex-col">
<!-- TopAppBar -->
<header class="flex justify-between items-center w-full px-4 h-16 bg-[#0C1821] z-50 fixed top-0 border-b border-[#2A3A4A]">
<div class="flex items-center gap-4">
<button class="flex items-center justify-center p-2 rounded-full active:scale-95 transition-transform text-[#7A8B9A] hover:bg-[#162029]">
<span class="material-symbols-outlined" data-icon="arrow_back">arrow_back</span>
</button>
<h1 class="font-['Inter'] font-bold tracking-tight uppercase text-lg text-[#E8ECF1]">Invite Opponent</h1>
</div>
<div class="flex items-center gap-3">
<span class="bg-primary-container text-on-primary-container px-3 py-1 rounded-full text-label-caps font-bold">3/3</span>
<button class="flex items-center justify-center p-2 text-[#7A8B9A]">
<span class="material-symbols-outlined" data-icon="more_vert">more_vert</span>
</button>
</div>
</header>
<main class="flex-1 mt-16 px-4 py-6 max-w-2xl mx-auto w-full">
<!-- Team Identity Header -->
<div class="mb-8 flex items-center justify-between bg-surface-container-high p-4 rounded-xl border border-outline-variant">
<div class="flex flex-col">
<span class="text-label-caps text-on-surface-variant mb-1">YOUR TEAM</span>
<span class="font-h2 text-primary">Royal Challengers</span>
</div>
<div class="h-12 w-12 rounded-lg bg-primary/20 flex items-center justify-center border border-primary/30">
<span class="material-symbols-outlined text-primary" style="font-variation-settings: 'FILL' 1;">sports_cricket</span>
</div>
</div>
<!-- Section 1: Connections -->
<section class="mb-10">
<div class="flex items-center justify-between mb-4">
<h2 class="font-h2 text-on-surface">Invite from Connections</h2>
<span class="text-body-sm text-on-surface-variant">24 Online</span>
</div>
<div class="relative mb-6">
<span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant">search</span>
<input class="w-full bg-surface-container-low border border-outline-variant rounded-lg py-3 pl-12 pr-4 text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-all placeholder:text-on-surface-variant/50" placeholder="Search by name or INS-ID" type="text"/>
</div>
<div class="space-y-3">
<!-- Player Card 1 (Already Invited) -->
<div class="flex items-center justify-between p-4 bg-surface-container rounded-xl border border-outline-variant">
<div class="flex items-center gap-4">
<img class="w-12 h-12 rounded-full border-2 border-primary/20" data-alt="A professional portrait of a cricket player with a focused expression, wearing a dark athletic training jersey. The background is a blurred high-tech locker room with green neon accents and technical data displays, matching a dark broadcast-ready sports aesthetic." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCvpw830U0ZCj_CFwZT44ORFPjYXqgswkDbehILcFYpc0i49JzP6j-LBapjh6KDGO3JJ2vuouS9h8i1LNfCHwRyduJoxNNmE6r2JBD4mAOxS4-D_OtTLmL9PnFEKnNpcfWQJHr4ipVXsSf1UKb0AEl5dcfJhRbqAOUJ_xkuQCTXAfvvhiyJzjZCtfq-fvED0Bc0vYjE35OLUPAZhc63NbM7unN9vr06bdtAmGj4prIMOTJYPTECq-CAgOasKSQqT4mojTT71FRgpBg"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface">Rohit Sharma</span>
<span class="text-body-sm text-on-surface-variant">INS-ID: 4452-99</span>
</div>
</div>
<button class="flex items-center gap-2 px-4 py-2 rounded-lg border border-primary/50 bg-primary/10 text-primary text-label-caps font-bold">
<span>Invited</span>
<span class="material-symbols-outlined text-sm" data-icon="check">check</span>
</button>
</div>
<!-- Player Card 2 -->
<div class="flex items-center justify-between p-4 bg-surface-container rounded-xl border border-outline-variant hover:bg-surface-container-high transition-colors">
<div class="flex items-center gap-4">
<img class="w-12 h-12 rounded-full border-2 border-outline/20" data-alt="A profile photograph of a professional cricket athlete in a high-contrast studio setting. Dramatic side-lighting highlights the contours of the face against a deep charcoal background with subtle emerald green light streaks, emphasizing a premium and competitive sports atmosphere." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDfOWajF4Q0u0z58sre4JBVIkFQUtNdgva_AaSOo-59gNgqlOuuNFKpR0mgdvlr064zfZ5FGtnvAm4OxucvffhEnn312xDFc9FMKEC8wyzSjTZYgA1mhVe-476zMzgqayC74wKNGrXpxN3rWWaeQfqw8myD0mT3XetQ4V7NbA-XVq62rV-KVRhvSc_fyRB3qG4hq5OaXniAYx7h7zF9LhKy9qZVEWpv076v7NHQmB_04YcR-mruOTGJZpfdITVfyx73logM_k2B95M"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface">Virat Kohli</span>
<span class="text-body-sm text-on-surface-variant">INS-ID: 1818-00</span>
</div>
</div>
<button class="px-6 py-2 rounded-lg border border-primary text-primary text-label-caps font-bold hover:bg-primary hover:text-on-primary transition-all active:scale-95">
                        Invite
                    </button>
</div>
<!-- Player Card 3 -->
<div class="flex items-center justify-between p-4 bg-surface-container rounded-xl border border-outline-variant hover:bg-surface-container-high transition-colors">
<div class="flex items-center gap-4">
<img class="w-12 h-12 rounded-full border-2 border-outline/20" data-alt="A sports headshot of a smiling cricket player in a team uniform, set against a dark architectural background of a modern stadium hallway. The lighting is technical and cool-toned, with bright white and cricket green highlights that define a professional broadcasting visual style." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBFcYv333-PG3CphRqGgcZxsZpFSx-5gv3FiLwhZHcRvG8Sbs7RYFYUnD9jObcMFoPH1_m47jGwTj3bST14FoNCHnjkZepD6NS5vZuWnwvvE-XiAnu1uoVjrpLTRtf5wTLqDm7R2tDpLGUZeZEG6F_fgbk-l2mHJEui1OVFCKyW09uyJGVxqFU56e-etyHQ38g-GZhnhPahkZUjxxGXJbdh8SxO_WzFYgyzCi4JVLPruNIAffm-eS02mSVggz3rInUbaBDnyUPIEew"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface">Shikhar Dhawan</span>
<span class="text-body-sm text-on-surface-variant">INS-ID: 0707-12</span>
</div>
</div>
<button class="px-6 py-2 rounded-lg border border-primary text-primary text-label-caps font-bold hover:bg-primary hover:text-on-primary transition-all active:scale-95">
                        Invite
                    </button>
</div>
</div>
</section>
<!-- Section 2: Share Link -->
<section class="mb-10">
<h2 class="font-h2 text-on-surface mb-4">Share Invite Link</h2>
<div class="bg-surface-container-low border-2 border-dashed border-outline-variant rounded-2xl p-6">
<div class="flex flex-col gap-4">
<div class="flex items-center justify-between bg-[#0C1821] p-4 rounded-lg border border-outline-variant">
<span class="font-score-sub text-primary tracking-widest uppercase">MATCH-CRT-XL992</span>
<button class="text-on-surface-variant hover:text-white transition-colors">
<span class="material-symbols-outlined" data-icon="content_copy">content_copy</span>
</button>
</div>
<div class="flex gap-3">
<button class="flex-1 flex items-center justify-center gap-2 py-3 rounded-lg bg-[#25D366]/20 border border-[#25D366]/30 text-[#25D366] font-bold text-sm">
<span class="material-symbols-outlined text-lg" data-icon="share">share</span>
                            WhatsApp
                        </button>
<button class="flex-1 flex items-center justify-center gap-2 py-3 rounded-lg bg-surface-container border border-outline-variant text-on-surface font-bold text-sm hover:bg-surface-container-high">
<span class="material-symbols-outlined text-lg" data-icon="more_horiz">more_horiz</span>
                            Others
                        </button>
</div>
</div>
</div>
</section>
<!-- Waiting State Card -->
<div class="relative overflow-hidden bg-surface-container-highest p-6 rounded-2xl border-l-4 border-primary shadow-xl">
<div class="flex items-center gap-5">
<div class="relative">
<img class="w-14 h-14 rounded-full border-2 border-primary" data-alt="A high-resolution digital render of a cricket captain silhouette against a glowing dark background. The scene is illuminated by circular ambient lighting in a deep slate blue and vivid cricket green, creating a sophisticated command-center atmosphere with a sense of high-stakes anticipation." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBs_OHycA8iZYKRuruNKXTRYVp8y1AoBYXCojhZEakSdAAmbFq97-nldjFpUwruLLNgyKVEiwJemKtoNaIZnzKDKU8X2et-vbcLBGY4N1RpvlvfC7_MkY2IRzxJRKonVTPj1vt8V8SPpsZrlfh7grLgIAhEC5l-su2ff9khzCOCG-o9uVM3a8r0L3jOyQXbSQS6jfr6dQ7XX4EPnTYq66InfNA4scIIpzXNI2G99ZVVeoeZdn3c61cj84_nJpTwsXRGAGTm7WN6bjQ"/>
<div class="absolute -bottom-1 -right-1 w-5 h-5 bg-primary rounded-full border-2 border-surface-container-highest flex items-center justify-center">
<span class="w-1.5 h-1.5 bg-on-primary rounded-full animate-ping"></span>
</div>
</div>
<div class="flex flex-col flex-1">
<p class="text-on-surface font-medium">Waiting for <span class="text-primary font-bold">Rohit Sharma</span> to accept...</p>
<div class="flex gap-1 mt-2">
<div class="w-1.5 h-1.5 bg-primary/40 rounded-full"></div>
<div class="w-1.5 h-1.5 bg-primary/70 rounded-full"></div>
<div class="w-1.5 h-1.5 bg-primary rounded-full"></div>
</div>
</div>
<button class="text-error font-label-caps p-2 hover:bg-error/10 rounded-lg transition-colors">CANCEL</button>
</div>
</div>
</main>
<!-- Bottom Action Area (Optional) -->
<footer class="fixed bottom-0 left-0 right-0 p-4 bg-surface-container-low border-t border-outline-variant">
<div class="max-w-2xl mx-auto">
<button class="w-full bg-primary text-on-primary py-4 rounded-xl font-h2 shadow-lg shadow-primary/20 active:scale-[0.98] transition-all">
                Finish Setup
            </button>
</div>
</footer>
</body></html>

<!-- Match Type Selection -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "error-container": "#93000a",
                        "on-primary-container": "#003115",
                        "primary-fixed-dim": "#75db92",
                        "secondary": "#c3c7cc",
                        "on-surface-variant": "#becabc",
                        "on-tertiary": "#630b23",
                        "surface-container-lowest": "#0a0f0b",
                        "surface-bright": "#353b35",
                        "outline": "#889488",
                        "tertiary-fixed": "#ffd9dc",
                        "secondary-fixed-dim": "#c3c7cc",
                        "on-error": "#690005",
                        "secondary-fixed": "#dfe3e8",
                        "on-primary-fixed": "#00210c",
                        "tertiary": "#ffb2bb",
                        "on-tertiary-fixed": "#400011",
                        "on-error-container": "#ffdad6",
                        "on-surface": "#dfe4dc",
                        "surface-tint": "#75db92",
                        "on-secondary-fixed-variant": "#42474b",
                        "on-tertiary-container": "#59031c",
                        "surface-container-highest": "#303630",
                        "surface-container-high": "#262b26",
                        "inverse-surface": "#dfe4dc",
                        "error": "#ffb4ab",
                        "tertiary-fixed-dim": "#ffb2bb",
                        "on-primary": "#003919",
                        "surface-variant": "#303630",
                        "inverse-primary": "#006d36",
                        "tertiary-container": "#df6d7f",
                        "on-secondary": "#2c3135",
                        "inverse-on-surface": "#2c322c",
                        "surface": "#0f1510",
                        "on-primary-fixed-variant": "#005227",
                        "on-background": "#dfe4dc",
                        "surface-container": "#1b211c",
                        "on-secondary-container": "#b1b6ba",
                        "on-tertiary-fixed-variant": "#812438",
                        "surface-dim": "#0f1510",
                        "secondary-container": "#42474b",
                        "primary-container": "#3ca360",
                        "outline-variant": "#3e4a3f",
                        "primary": "#75db92",
                        "on-secondary-fixed": "#171c20",
                        "surface-container-low": "#171d18",
                        "primary-fixed": "#91f8ac",
                        "background": "#0f1510"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "gutter": "12px",
                        "xl": "32px",
                        "lg": "24px",
                        "sm": "8px",
                        "md": "16px",
                        "base": "8px",
                        "xs": "4px",
                        "container-padding": "16px"
                    },
                    "fontFamily": {
                        "label-caps": ["Inter"],
                        "h1": ["Inter"],
                        "score-display": ["JetBrains Mono"],
                        "h2": ["Inter"],
                        "score-sub": ["JetBrains Mono"],
                        "body-md": ["Inter"],
                        "body-sm": ["Inter"]
                    },
                    "fontSize": {
                        "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                        "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                        "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}]
                    }
                }
            }
        }
    </script>
<style>
        .pulse-ring { animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite; }
        @keyframes pulse { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: .5; transform: scale(1.1); } }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-[#0C1821] text-on-surface font-body-md min-h-screen">
<!-- TopAppBar from JSON -->
<header class="flex justify-between items-center w-full px-4 h-16 bg-[#0C1821] z-50 docked full-width top-0 border-b border-[#2A3A4A] shadow-none">
<div class="flex items-center gap-4">
<button class="active:scale-98 transition-transform duration-150 hover:bg-[#162029] hover:text-white p-2 rounded-full">
<span class="material-symbols-outlined text-[#1B8A4A]">arrow_back</span>
</button>
<div class="flex flex-col">
<h1 class="font-['Inter'] font-bold tracking-tight uppercase text-[#1B8A4A] leading-tight">Match Setup</h1>
<span class="text-xs text-[#7A8B9A] font-medium">Royal Challengers vs Mumbai Indians</span>
</div>
</div>
<button class="active:scale-98 transition-transform duration-150 hover:bg-[#162029] hover:text-white p-2 rounded-full">
<span class="material-symbols-outlined text-[#1B8A4A]">more_vert</span>
</button>
</header>
<main class="p-container-padding max-w-2xl mx-auto space-y-lg">
<!-- Progress Stepper -->
<section class="flex justify-between items-center px-lg py-md bg-[#162029] border border-[#2A3A4A] rounded-xl shadow-sm">
<div class="flex flex-col items-center gap-xs">
<div class="w-8 h-8 rounded-full bg-[#1B8A4A] flex items-center justify-center text-[#E8ECF1]">
<span class="material-symbols-outlined text-sm" style="font-variation-settings: 'FILL' 1;">check</span>
</div>
<span class="font-label-caps text-[10px] text-[#7A8B9A] uppercase">Invite</span>
</div>
<div class="flex-1 h-[2px] bg-[#2A3A4A] mx-xs mb-5">
<div class="h-full bg-[#1B8A4A] w-full"></div>
</div>
<div class="flex flex-col items-center gap-xs">
<div class="relative flex items-center justify-center">
<div class="absolute w-10 h-10 border-2 border-[#1B8A4A] rounded-full pulse-ring"></div>
<div class="w-8 h-8 rounded-full bg-[#1B8A4A] flex items-center justify-center text-[#E8ECF1] font-bold text-xs relative z-10">2</div>
</div>
<span class="font-label-caps text-[10px] text-[#1B8A4A] uppercase">Teams</span>
</div>
<div class="flex-1 h-[2px] bg-[#2A3A4A] mx-xs mb-5"></div>
<div class="flex flex-col items-center gap-xs opacity-40">
<div class="w-8 h-8 rounded-full border-2 border-[#7A8B9A] flex items-center justify-center">
<span class="material-symbols-outlined text-sm">lock</span>
</div>
<span class="font-label-caps text-[10px] text-[#7A8B9A] uppercase">Rules</span>
</div>
<div class="flex-1 h-[2px] bg-[#2A3A4A] mx-xs mb-5"></div>
<div class="flex flex-col items-center gap-xs opacity-40">
<div class="w-8 h-8 rounded-full border-2 border-[#7A8B9A] flex items-center justify-center">
<span class="material-symbols-outlined text-sm">lock</span>
</div>
<span class="font-label-caps text-[10px] text-[#7A8B9A] uppercase">Toss</span>
</div>
</section>
<!-- Teams Section -->
<div class="space-y-md">
<!-- Your Team Card -->
<div class="bg-[#162029] border border-[#2A3A4A] rounded-xl overflow-hidden">
<div class="p-md border-b border-[#2A3A4A] flex justify-between items-center bg-[#1E2D3D]/30">
<div class="flex items-center gap-md">
<div class="w-10 h-10 rounded-lg bg-[#630b23] flex items-center justify-center text-white font-black text-xl tracking-tighter">RC</div>
<div>
<h2 class="font-h2 text-on-surface">Your Team</h2>
<p class="text-body-sm text-[#7A8B9A]">3 / 6 Players Joined</p>
</div>
</div>
<button class="text-[#1B8A4A] hover:bg-[#1B8A4A]/10 p-2 rounded-full transition-colors">
<span class="material-symbols-outlined">edit</span>
</button>
</div>
<div class="p-md space-y-sm">
<div class="grid grid-cols-1 sm:grid-cols-2 gap-sm">
<!-- Player 1 -->
<div class="flex items-center gap-md p-sm bg-[#0C1821] rounded-lg border border-[#2A3A4A]">
<img class="w-10 h-10 rounded-full object-cover" data-alt="Close-up portrait of a professional cricket player in a team jersey, studio lighting with a dark dramatic background, high contrast, cinematic photography style focusing on the determined expression and athletic features of a captain." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCIzVuN9gZ5gZHX1VdgQWnR9VMclsHsvERxxsY2IJdVvpohr-u5khUeckwti4MFjy7614_8jr3qCMFJKNYg1jVP905hI68hIjYN0ZkJm8tPjoE3I9qv5KKxqrYKl8dteakIsmc8ypXs7qVDeo_EzHoZvetHMh0tK_tIWxcA1b2lZ6vf7_OSDnO36yAJbZebI_ijAucyd0D_s3KyBkmDzLExwP58_1Ng28XvYgXjwSQX3OQNzAUCDQalfljE1PoTPs3A4A_ENedeDk4"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface text-sm">You <span class="text-[#1B8A4A] text-[10px] ml-1">(C)</span></span>
<span class="text-[10px] text-[#7A8B9A] uppercase font-bold">All-Rounder</span>
</div>
</div>
<!-- Player 2 -->
<div class="flex items-center gap-md p-sm bg-[#0C1821] rounded-lg border border-[#2A3A4A]">
<img class="w-10 h-10 rounded-full object-cover" data-alt="A profile headshot of a sportsman with short hair and a confident smile, wearing a dark athletic polo shirt. Soft key lighting highlights facial contours against a deep charcoal gray backdrop, evoking a premium sports broadcast profile aesthetic." src="https://lh3.googleusercontent.com/aida-public/AB6AXuByYObdHK88iz4uVpfG7wTEMpFXEBC8ZNY7ClGqIU8WIAxSBwYK5jlJr7xFGDXbELQLJm3INnp9qZQS4I0U585AH6BJBBzD9zps-bvZKWwPh4l6CcR-nUPXOtxakIbtQ0T8kMQjyWeevT6wVnP3ZXQJhOUPwaY-Ql70RY5qsxuijX_xngXPVhkRXhGVsEmwRjbhngry-Ly6P08InsV_lsKRFwA42VskibhqhwSdfFfXGYwPMmgWquaymL6mLBMThhK4XIKNqIfHdGE"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface text-sm">AB</span>
<span class="text-[10px] text-[#7A8B9A] uppercase font-bold">Wicket Keeper</span>
</div>
</div>
<!-- Player 3 -->
<div class="flex items-center gap-md p-sm bg-[#0C1821] rounded-lg border border-[#2A3A4A]">
<img class="w-10 h-10 rounded-full object-cover" data-alt="Cleanly styled portrait of a young male athlete in sports attire, professional lighting with rim light to separate from the dark navy background. The style is sharp and modern, suitable for a high-end sports application player profile." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDQa3QLEXCXrkBE0nsebFv2oBARzVU1XM4YZZq20AVoeef9LwO1HJVpUnKdJ4IJ4KRXTR6ydEKOodZh3rUum2_AJB75WYX5VsiAFb5aWxf1UYfctSv0Zk46CxjOQ3UrGnPgkXwym4HkTW00G0qW7jmev3qpOs8bdFHAFhnBPTQXLZcAz7T4dSu-HLVRhiiJSgbUMprwfp1X7_hP83KUL3zSemVpE_HCkoJFQjyNiGpFnqeW7j8Rp86-0bJ3NYWTNN6dHxpMxn5S8Cg"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface text-sm">Glenn</span>
<span class="text-[10px] text-[#7A8B9A] uppercase font-bold">Power Hitter</span>
</div>
</div>
<!-- Add Player Button -->
<button class="flex items-center justify-center gap-sm p-sm border-2 border-dashed border-[#2A3A4A] rounded-lg hover:border-[#1B8A4A] hover:bg-[#1B8A4A]/5 transition-all group">
<span class="material-symbols-outlined text-[#7A8B9A] group-hover:text-[#1B8A4A]">add_circle</span>
<span class="text-sm font-bold text-[#7A8B9A] group-hover:text-[#1B8A4A]">Add Player</span>
</button>
</div>
</div>
<div class="p-md bg-[#1B8A4A]/5 border-t border-[#2A3A4A]">
<button class="w-full bg-[#1B8A4A] text-[#E8ECF1] py-3 rounded-lg font-bold text-sm tracking-wide uppercase shadow-lg shadow-[#1B8A4A]/20 active:scale-[0.98] transition-transform">
                        Mark Ready
                    </button>
</div>
</div>
<!-- Their Team Card -->
<div class="bg-[#162029] border border-[#2A3A4A] rounded-xl overflow-hidden opacity-90">
<div class="p-md border-b border-[#2A3A4A] flex justify-between items-center bg-[#1E2D3D]/30">
<div class="flex items-center gap-md">
<div class="w-10 h-10 rounded-lg bg-[#005227] flex items-center justify-center text-white font-black text-xl tracking-tighter">MI</div>
<div>
<h2 class="font-h2 text-on-surface">Their Team</h2>
<p class="text-body-sm text-[#7A8B9A]">2 / 6 Players Joined</p>
</div>
</div>
<div class="flex items-center gap-xs px-sm py-1 bg-tertiary-container/20 rounded-full">
<div class="w-2 h-2 rounded-full bg-tertiary pulse-ring"></div>
<span class="text-[10px] font-bold text-tertiary uppercase">Adding players...</span>
</div>
</div>
<div class="p-md">
<div class="grid grid-cols-1 sm:grid-cols-2 gap-sm">
<!-- Opponent Player 1 -->
<div class="flex items-center gap-md p-sm bg-[#0C1821] rounded-lg border border-[#2A3A4A] opacity-80">
<img class="w-10 h-10 rounded-full object-cover" data-alt="Athletic male portrait with a focused gaze, wearing a team uniform with subtle patterns. The image is lit from the side with a blue-toned rim light against a dark, textured studio wall, creating a serious and competitive atmosphere." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDT9DIL7K8ApocNGi77Jlcld_tiyInpt4s40m28kmH4OOj2HByhjaGZlBlbrk-uyYDWLFm0AGoLcwFNAPcGMxBO3MOEmH_SW6wpR5kE9dMlf7dg9LZWqdrcFCZAdy_8jupxU77ehOs6yonBOIWSR4bzo0f2gUtzntAxVm0pX52K0jemFzuSKvgxZN9Uw0YZb1u4w8-rHTym0lFMmGKkb7UPkXBXJW0lAnAyEF2DctBS04tBVzkmCU-vukodgMbxYngCNpvy4zq1qNs"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface text-sm">Rohit <span class="text-[#7A8B9A] text-[10px] ml-1">(C)</span></span>
<span class="text-[10px] text-[#7A8B9A] uppercase font-bold">Opening Batsman</span>
</div>
</div>
<!-- Opponent Player 2 -->
<div class="flex items-center gap-md p-sm bg-[#0C1821] rounded-lg border border-[#2A3A4A] opacity-80">
<img class="w-10 h-10 rounded-full object-cover" data-alt="A sharp, medium close-up of a fit young man in sportswear. Professional sports broadcasting aesthetics with localized spotlighting on the face, creating deep shadows and high highlights for a high-stakes competitive mood." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAYmpnzguX2kewAr4gNB26tIwybT8KDMf4CLVTURWwxPYZ9PyugiaZsa_VLqN75F5fWVE-D9vR88W_DfBrU9JsKNvDC2Q9ROXR4pELFkeMS1cmNy68VBjdfNTQVepUWLOkUeSUevAg42mrfKX1divZgsRYJ6RPHt1Z56Iox7GYr3xqNP5gkQiaVomz0WzFq_y6MPtFAjxrif_h3bjs420rOvXmGhp7RTaur7UDYnmABeYtpwzXpl9vdg2HV6P_qFAZ6s5Fz1xLdeLM"/>
<div class="flex flex-col">
<span class="font-bold text-on-surface text-sm">Jasprit</span>
<span class="text-[10px] text-[#7A8B9A] uppercase font-bold">Strike Bowler</span>
</div>
</div>
<!-- Placeholder Slots -->
<div class="flex items-center justify-center p-sm border border-[#2A3A4A] border-dotted rounded-lg bg-[#0C1821]/50 h-14">
<div class="flex flex-col items-center">
<div class="w-4 h-1 bg-[#2A3A4A] rounded-full"></div>
<span class="text-[9px] text-[#7A8B9A] uppercase mt-1">Waiting...</span>
</div>
</div>
<div class="flex items-center justify-center p-sm border border-[#2A3A4A] border-dotted rounded-lg bg-[#0C1821]/50 h-14">
<div class="flex flex-col items-center">
<div class="w-4 h-1 bg-[#2A3A4A] rounded-full"></div>
<span class="text-[9px] text-[#7A8B9A] uppercase mt-1">Waiting...</span>
</div>
</div>
</div>
</div>
</div>
</div>
<!-- Notification / Info Banner -->
<div class="flex items-start gap-md p-md bg-[#1B8A4A]/10 border border-[#1B8A4A]/20 rounded-xl">
<span class="material-symbols-outlined text-[#1B8A4A]">info</span>
<div class="flex flex-col gap-xs">
<span class="text-sm font-bold text-on-surface">Finalizing Team Rosters</span>
<p class="text-xs text-[#7A8B9A] leading-relaxed">Match can start once both captains have marked their teams as ready. You can still modify your lineup until then.</p>
</div>
</div>
</main>
<!-- Bottom Action Area (Floating style instead of nav) -->
<div class="fixed bottom-0 left-0 w-full p-container-padding pointer-events-none">
<div class="max-w-2xl mx-auto flex justify-end pointer-events-auto">
<button class="bg-[#1B8A4A] text-[#E8ECF1] w-14 h-14 rounded-full flex items-center justify-center shadow-2xl active:scale-95 transition-transform">
<span class="material-symbols-outlined text-2xl">share</span>
</button>
</div>
</div>
</body></html>

<!-- Match Rules -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "error-container": "#93000a",
                    "on-primary-container": "#003115",
                    "secondary": "#c3c7cc",
                    "on-surface-variant": "#becabc",
                    "primary-fixed-dim": "#75db92",
                    "surface-container-lowest": "#0a0f0b",
                    "on-tertiary": "#630b23",
                    "surface-bright": "#353b35",
                    "outline": "#889488",
                    "tertiary-fixed": "#ffd9dc",
                    "secondary-fixed": "#dfe3e8",
                    "on-primary-fixed": "#00210c",
                    "secondary-fixed-dim": "#c3c7cc",
                    "on-error": "#690005",
                    "on-surface": "#dfe4dc",
                    "tertiary": "#ffb2bb",
                    "on-tertiary-fixed": "#400011",
                    "on-error-container": "#ffdad6",
                    "surface-tint": "#75db92",
                    "on-secondary-fixed-variant": "#42474b",
                    "surface-container-high": "#262b26",
                    "inverse-surface": "#dfe4dc",
                    "on-tertiary-container": "#59031c",
                    "surface-container-highest": "#303630",
                    "surface-variant": "#303630",
                    "inverse-primary": "#006d36",
                    "error": "#ffb4ab",
                    "tertiary-fixed-dim": "#ffb2bb",
                    "on-primary": "#003919",
                    "inverse-on-surface": "#2c322c",
                    "surface": "#0f1510",
                    "tertiary-container": "#df6d7f",
                    "on-secondary": "#2c3135",
                    "surface-container": "#1b211c",
                    "on-primary-fixed-variant": "#005227",
                    "on-background": "#dfe4dc",
                    "on-tertiary-fixed-variant": "#812438",
                    "on-secondary-container": "#b1b6ba",
                    "surface-dim": "#0f1510",
                    "secondary-container": "#42474b",
                    "primary-container": "#3ca360",
                    "outline-variant": "#3e4a3f",
                    "primary": "#75db92",
                    "on-secondary-fixed": "#171c20",
                    "primary-fixed": "#91f8ac",
                    "background": "#0f1510",
                    "surface-container-low": "#171d18"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "lg": "24px",
                    "sm": "8px",
                    "gutter": "12px",
                    "xl": "32px",
                    "xs": "4px",
                    "container-padding": "16px",
                    "md": "16px",
                    "base": "8px"
            },
            "fontFamily": {
                    "body-sm": ["Inter"],
                    "score-sub": ["JetBrains Mono"],
                    "body-md": ["Inter"],
                    "label-caps": ["Inter"],
                    "score-display": ["JetBrains Mono"],
                    "h2": ["Inter"],
                    "h1": ["Inter"]
            },
            "fontSize": {
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                    "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                    "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
        body {
            background-color: #0C1821;
            background-image: radial-gradient(#1B8A4A11 1px, transparent 1px);
            background-size: 24px 24px;
            color: #dfe4dc;
        }
        .pulse-dot {
            animation: pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: .3; }
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="min-h-screen font-body-md flex flex-col p-md max-w-lg mx-auto">
<!-- Header Section -->
<header class="flex flex-col gap-sm mb-lg pt-sm">
<div class="flex justify-between items-center">
<div class="flex items-center gap-base px-3 py-1 bg-[#EF4444] rounded-full">
<span class="w-2 h-2 bg-white rounded-full pulse-dot"></span>
<span class="text-white font-label-caps text-[10px] tracking-widest">LIVE</span>
</div>
<span class="font-label-caps text-on-surface-variant bg-surface-container px-2 py-1 rounded border border-outline-variant">T10 LEAGUE</span>
</div>
<h2 class="font-h2 text-h2 text-on-surface leading-tight mt-sm">
            Royal Challengers vs Mumbai Indians
        </h2>
</header>
<!-- Main Score Card -->
<main class="flex flex-col gap-md flex-grow">
<section class="bg-surface-container p-lg rounded-xl border border-outline-variant shadow-2xl relative overflow-hidden">
<!-- Decorative gradient mask -->
<div class="absolute top-0 right-0 w-32 h-32 bg-primary/5 rounded-full -mr-16 -mt-16 blur-3xl"></div>
<div class="flex flex-col gap-xs relative z-10">
<div class="flex items-baseline gap-sm">
<span class="font-score-display text-[48px] text-primary">184/4</span>
<span class="font-score-sub text-on-surface-variant">(18.2 ov)</span>
</div>
<div class="flex flex-col border-t border-outline-variant/30 pt-sm mt-sm">
<span class="font-label-caps text-on-surface-variant flex items-center justify-between">
<span>TARGET: <span class="text-on-surface">210</span></span>
<span>RRR: <span class="text-error">15.60</span></span>
</span>
</div>
</div>
</section>
<!-- Current Over -->
<section class="flex flex-col gap-sm px-base">
<h3 class="font-label-caps text-on-surface-variant">THIS OVER</h3>
<div class="flex gap-gutter overflow-x-auto pb-base no-scrollbar">
<!-- Ball 1 -->
<div class="w-8 h-8 rounded-full border border-primary text-primary flex items-center justify-center font-score-sub text-sm bg-primary/5">4</div>
<!-- Ball 2 -->
<div class="w-8 h-8 rounded-full border border-outline-variant text-on-surface-variant flex items-center justify-center font-score-sub text-sm">.</div>
<!-- Ball 3 -->
<div class="w-8 h-8 rounded-full border-2 border-primary text-primary flex items-center justify-center font-score-sub text-sm font-bold bg-primary/10 shadow-[0_0_8px_rgba(117,219,146,0.3)]">6</div>
<!-- Ball 4 -->
<div class="w-8 h-8 rounded-full bg-[#EF4444] text-white flex items-center justify-center font-score-sub text-sm font-bold shadow-lg shadow-error-container/20">W</div>
<!-- Ball 5 -->
<div class="w-8 h-8 rounded-full border border-outline-variant text-on-surface flex items-center justify-center font-score-sub text-sm">1</div>
<!-- Next ball indicator -->
<div class="w-8 h-8 rounded-full border-2 border-dashed border-outline-variant/50 flex items-center justify-center opacity-30"></div>
</div>
</section>
<!-- Player Stats Bento -->
<section class="grid grid-cols-1 gap-sm">
<!-- Batsmen -->
<div class="bg-surface-container-low border border-outline-variant rounded-lg overflow-hidden">
<div class="px-md py-sm bg-surface-container-high border-b border-outline-variant flex justify-between items-center">
<span class="font-label-caps text-on-surface-variant">BATSMEN</span>
<span class="font-label-caps text-[10px] text-primary">STRK</span>
</div>
<div class="p-md space-y-md">
<div class="flex justify-between items-center">
<div class="flex flex-col">
<span class="font-body-md font-bold text-on-surface">V Kohli *</span>
<span class="text-[10px] text-on-surface-variant uppercase tracking-widest font-bold">SR 200.00</span>
</div>
<div class="flex items-baseline gap-xs">
<span class="font-score-sub text-xl text-primary">64</span>
<span class="font-score-sub text-sm text-on-surface-variant">(32)</span>
</div>
</div>
<div class="h-[1px] bg-outline-variant/20"></div>
<div class="flex justify-between items-center opacity-80">
<div class="flex flex-col">
<span class="font-body-md text-on-surface">AB de Villiers</span>
<span class="text-[10px] text-on-surface-variant uppercase tracking-widest">SR 155.56</span>
</div>
<div class="flex items-baseline gap-xs">
<span class="font-score-sub text-xl text-on-surface">28</span>
<span class="font-score-sub text-sm text-on-surface-variant">(18)</span>
</div>
</div>
</div>
</div>
<!-- Bowler -->
<div class="bg-surface-container-low border border-outline-variant rounded-lg overflow-hidden">
<div class="px-md py-sm bg-surface-container-high border-b border-outline-variant">
<span class="font-label-caps text-on-surface-variant">BOWLER</span>
</div>
<div class="p-md flex justify-between items-center">
<div class="flex flex-col">
<span class="font-body-md font-bold text-on-surface">J Bumrah</span>
<span class="text-[10px] text-on-surface-variant uppercase tracking-widest font-bold">ECON 7.20</span>
</div>
<div class="flex flex-col items-end">
<span class="font-score-sub text-xl text-on-surface">2-24</span>
<span class="font-score-sub text-sm text-on-surface-variant">3.2 ov</span>
</div>
</div>
</div>
</section>
<!-- Broadcast Visual Element -->
<div class="w-full h-32 rounded-lg bg-surface relative overflow-hidden group">
<img class="w-full h-full object-cover opacity-40 mix-blend-luminosity" data-alt="A wide cinematic shot of a packed high-tech cricket stadium at night under brilliant floodlights. The scene captures the electric atmosphere with a haze of light and mist over the green field. The color palette is dominated by deep night blues, vibrant stadium greens, and neon white lights. The overall style is high-end sports broadcast cinematography with a sharp, professional lens." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBciry_486coiuCSb69qLcwmiE58oQNgycgfoapobkRX7-VG95SqKbXd_TxqPfAvpJcDYclNycb0r6XCjuUWMIx086R56VftO9EzZIDzVRj71EwsrJX8ruyh_HEZOcbQ7Pbrba4EWUvsXUAyVI_cyzjaM9jotyrGz08K-qwNW8UULRw2heV0oWotL8yxC3qDso2VTfaFQB42nEivrYlxcJBtYkYa7e2WQltsvgvQlk6iW3ebFU3AdBdeWaILYThaXNUBkhgdHVDoRU"/>
<div class="absolute inset-0 bg-gradient-to-t from-surface to-transparent"></div>
<div class="absolute bottom-sm left-md">
<span class="font-label-caps text-primary text-[10px] flex items-center gap-xs">
<span class="material-symbols-outlined text-sm">stadium</span>
                    Wankhede Stadium, Mumbai
                </span>
</div>
</div>
</main>
<!-- Footer -->
<footer class="mt-xl pb-lg flex flex-col items-center gap-base opacity-40 grayscale">
<div class="flex items-center gap-sm">
<div class="w-6 h-6 bg-on-surface text-surface rounded-sm flex items-center justify-center font-black italic text-xs">iS</div>
<span class="font-label-caps text-[10px] tracking-tighter">Powered by inSwing</span>
</div>
<div class="flex gap-md">
<span class="w-1.5 h-1.5 rounded-full bg-outline-variant"></span>
<span class="w-1.5 h-1.5 rounded-full bg-outline-variant"></span>
<span class="w-1.5 h-1.5 rounded-full bg-outline-variant"></span>
</div>
</footer>
</body></html>

<!-- Invite Opponent -->
<!DOCTYPE html>

<html class="dark" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=JetBrains+Mono:wght@500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "error-container": "#93000a",
                        "on-primary-container": "#003115",
                        "secondary": "#c3c7cc",
                        "on-surface-variant": "#becabc",
                        "primary-fixed-dim": "#75db92",
                        "surface-container-lowest": "#0a0f0b",
                        "on-tertiary": "#630b23",
                        "surface-bright": "#353b35",
                        "outline": "#889488",
                        "tertiary-fixed": "#ffd9dc",
                        "secondary-fixed": "#dfe3e8",
                        "on-primary-fixed": "#00210c",
                        "secondary-fixed-dim": "#c3c7cc",
                        "on-error": "#690005",
                        "on-surface": "#dfe4dc",
                        "tertiary": "#ffb2bb",
                        "on-tertiary-fixed": "#400011",
                        "on-error-container": "#ffdad6",
                        "surface-tint": "#75db92",
                        "on-secondary-fixed-variant": "#42474b",
                        "surface-container-high": "#262b26",
                        "inverse-surface": "#dfe4dc",
                        "on-tertiary-container": "#59031c",
                        "surface-container-highest": "#303630",
                        "surface-variant": "#303630",
                        "inverse-primary": "#006d36",
                        "error": "#ffb4ab",
                        "tertiary-fixed-dim": "#ffb2bb",
                        "on-primary": "#003919",
                        "inverse-on-surface": "#2c322c",
                        "surface": "#0f1510",
                        "tertiary-container": "#df6d7f",
                        "on-secondary": "#2c3135",
                        "surface-container": "#1b211c",
                        "on-primary-fixed-variant": "#005227",
                        "on-background": "#dfe4dc",
                        "on-tertiary-fixed-variant": "#812438",
                        "on-secondary-container": "#b1b6ba",
                        "surface-dim": "#0f1510",
                        "secondary-container": "#42474b",
                        "primary-container": "#3ca360",
                        "outline-variant": "#3e4a3f",
                        "primary": "#75db92",
                        "on-secondary-fixed": "#171c20",
                        "primary-fixed": "#91f8ac",
                        "background": "#0f1510",
                        "surface-container-low": "#171d18"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "lg": "24px",
                        "sm": "8px",
                        "gutter": "12px",
                        "xl": "32px",
                        "xs": "4px",
                        "container-padding": "16px",
                        "md": "16px",
                        "base": "8px"
                    },
                    "fontFamily": {
                        "body-sm": ["Inter"],
                        "score-sub": ["JetBrains Mono"],
                        "body-md": ["Inter"],
                        "label-caps": ["Inter"],
                        "score-display": ["JetBrains Mono"],
                        "h2": ["Inter"],
                        "h1": ["Inter"]
                    },
                    "fontSize": {
                        "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "score-sub": ["18px", {"lineHeight": "24px", "fontWeight": "500"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "label-caps": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                        "score-display": ["36px", {"lineHeight": "40px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "h2": ["20px", {"lineHeight": "28px", "fontWeight": "700"}],
                        "h1": ["24px", {"lineHeight": "32px", "fontWeight": "700"}]
                    }
                },
            },
        }
    </script>
<style>
        body {
            background-color: #0C1821;
            background-image: radial-gradient(circle at 2px 2px, #162029 1px, transparent 0);
            background-size: 24px 24px;
        }
        .confetti-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
            opacity: 0.4;
            background-image: 
                radial-gradient(2px 2px at 20px 30px, #75db92, rgba(0,0,0,0)),
                radial-gradient(2px 2px at 40px 70px, #75db92, rgba(0,0,0,0)),
                radial-gradient(2px 2px at 50px 160px, #ffffff, rgba(0,0,0,0)),
                radial-gradient(2px 2px at 80px 120px, #75db92, rgba(0,0,0,0)),
                radial-gradient(2px 2px at 110px 40px, #ffffff, rgba(0,0,0,0)),
                radial-gradient(2px 2px at 150px 100px, #75db92, rgba(0,0,0,0));
            background-size: 200px 200px;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="text-on-background min-h-screen flex flex-col font-body-md">
<div class="confetti-overlay"></div>
<!-- Top App Bar (Shared Component) -->
<header class="fixed top-0 left-0 w-full z-50 flex justify-between items-center px-4 h-16 bg-[#0C1821] border-b border-[#2A3A4A]">
<div class="flex items-center gap-4">
<button class="material-symbols-outlined text-white hover:bg-[#162029] transition-colors p-2 rounded-full">menu</button>
<h1 class="text-xl font-black italic tracking-tighter text-white font-['Inter'] uppercase">CRICKET LIVE</h1>
</div>
<button class="material-symbols-outlined text-white hover:bg-[#162029] transition-colors p-2 rounded-full">notifications</button>
</header>
<main class="flex-grow pt-24 pb-12 px-container-padding max-w-lg mx-auto w-full relative z-10">
<!-- Result Card -->
<section class="bg-surface-container rounded-xl p-xl border border-outline-variant flex flex-col items-center text-center mb-md shadow-2xl">
<div class="mb-md">
<span class="material-symbols-outlined text-[48px] text-primary" style="font-variation-settings: 'FILL' 1;">emoji_events</span>
</div>
<h1 class="font-h1 text-h1 text-primary font-bold mb-xs">ROYAL CHALLENGERS WON</h1>
<h2 class="font-h2 text-h2 text-on-surface mb-lg">by 26 runs</h2>
<!-- Score Summary -->
<div class="grid grid-cols-2 gap-gutter w-full border-t border-outline-variant pt-lg mt-sm">
<div class="flex flex-col items-center border-r border-outline-variant">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-1">ROYAL CHALLENGERS</span>
<span class="font-score-display text-score-display text-primary">184/4</span>
<span class="font-score-sub text-score-sub text-on-surface-variant">(20 ov)</span>
</div>
<div class="flex flex-col items-center opacity-60">
<span class="font-label-caps text-label-caps text-on-surface-variant mb-1">MUMBAI INDIANS</span>
<span class="font-score-display text-score-display text-on-surface">158/8</span>
<span class="font-score-sub text-score-sub text-on-surface-variant">(20 ov)</span>
</div>
</div>
</section>
<!-- Match Highlights Card -->
<section class="bg-surface-container rounded-xl border border-outline-variant overflow-hidden mb-xl">
<div class="bg-surface-container-high px-md py-sm border-b border-outline-variant">
<h3 class="font-label-caps text-label-caps text-primary">MATCH HIGHLIGHTS</h3>
</div>
<div class="p-md space-y-md">
<!-- Top Scorer -->
<div class="flex items-center gap-md">
<div class="w-10 h-10 rounded-lg bg-surface-container-highest flex items-center justify-center border border-outline-variant">
<span class="material-symbols-outlined text-primary">sports_cricket</span>
</div>
<div class="flex-grow">
<p class="font-label-caps text-label-caps text-on-surface-variant">Top Scorer</p>
<p class="font-body-md text-body-md font-bold text-on-surface">V Kohli - 64 (32)</p>
</div>
</div>
<!-- Best Bowler -->
<div class="flex items-center gap-md">
<div class="w-10 h-10 rounded-lg bg-surface-container-highest flex items-center justify-center border border-outline-variant">
<span class="material-symbols-outlined text-primary">sports_baseball</span>
</div>
<div class="flex-grow">
<p class="font-label-caps text-label-caps text-on-surface-variant">Best Bowler</p>
<p class="font-body-md text-body-md font-bold text-on-surface">J Bumrah - 2/24</p>
</div>
</div>
<!-- Most 6s -->
<div class="flex items-center gap-md">
<div class="w-10 h-10 rounded-lg bg-surface-container-highest flex items-center justify-center border border-outline-variant">
<span class="material-symbols-outlined text-primary" style="font-variation-settings: 'FILL' 1;">star</span>
</div>
<div class="flex-grow">
<p class="font-label-caps text-label-caps text-on-surface-variant">Most 6s</p>
<p class="font-body-md text-body-md font-bold text-on-surface">AB de Villiers (4)</p>
</div>
</div>
</div>
</section>
<!-- Action Buttons -->
<div class="space-y-md">
<button class="w-full h-14 bg-primary text-on-primary-container rounded-lg font-h2 flex items-center justify-center gap-sm active:scale-95 transition-transform">
<span class="material-symbols-outlined">share</span>
                Share Result
            </button>
<button class="w-full h-14 border border-outline-variant text-on-surface rounded-lg font-h2 flex items-center justify-center gap-sm hover:bg-surface-container-highest active:scale-95 transition-all">
                View Full Scorecard
            </button>
<button class="w-full h-14 text-on-surface-variant rounded-lg font-body-md flex items-center justify-center gap-sm hover:text-white transition-colors">
                Back to Dashboard
            </button>
</div>
<!-- Team Logos Section (Visual Depth) -->
<div class="mt-xl flex justify-center items-center gap-xl opacity-20 grayscale">
<div class="w-16 h-16 rounded-full bg-surface-container-highest border border-outline-variant flex items-center justify-center overflow-hidden">
<img alt="RC" data-alt="A stylized professional sports team logo for the Royal Challengers, featuring a bold red and gold crest with a regal lion. The design is modern and clean, set against a dark architectural background in a high-stakes broadcast sports studio environment. Soft cinematic lighting highlights the sharp metallic edges of the emblem." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCnNgy3LzWc7xFBELoTlhN91HQvHhLT5hy0eO0ZfVZSW5xlpuBirsToG1t267QDRJ-K3j2CLuL_sf2PRyikCCxafj84tJq4QNdcu2Z9XManXmvcaFzpPAdRilMCsVonk0eSDZH-gcsvyYOylD8WhBeqA81-Cs9yklthsDjWqYheHHTvf9NhMa5ELT-4DtNzs26yvf87ZO_r0MG6MKHZ4vg7OxNBaJHzugInxYyVNqNk8bm3EncSX5Ryia1vtI-g5sQOkHZNqDvORDk"/>
</div>
<div class="text-on-surface-variant font-black italic text-xl">VS</div>
<div class="w-16 h-16 rounded-full bg-surface-container-highest border border-outline-variant flex items-center justify-center overflow-hidden">
<img alt="MI" data-alt="A sophisticated professional sports team logo for the Mumbai Indians, showcasing a dynamic blue and silver cyclone symbol. The aesthetic is futuristic and high-tech, fitting for a premium sports broadcast interface. The environment is a dark, moody stadium interior with subtle green ambient glows from field lighting." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCzvASqGNYIcNBOP78yJozhc35WuJf4w-v47jur3B29pkkSCHqqJvE0vXfIeXgaWQzEHI1wGqhxQoSPlsWOmKY5xp9fL64lrnwBth65jIzidVjVF_WZAXRWVr7GJIOHi9TH_HQvYgFkZO7Ke4M3uYnI5ZCWAvrFMCsLrYRd9U4JkCRDwPkA7rw88yWeKswDYdep4Qt53nkh0FrlluFa4wU3d4YEYA6JYST9sAzdqTDdHh5oTfFxl9eX2nS7VZKYI75vcUi1MI0cbeY"/>
</div>
</div>
</main>
<!-- Post-Match Summary Visual -->
<div class="w-full mt-auto px-container-padding pb-xl">
<div class="rounded-xl overflow-hidden border border-outline-variant h-40 relative">
<div class="absolute inset-0 bg-gradient-to-t from-background to-transparent z-10"></div>
<div class="absolute inset-0 flex items-center justify-center z-20">
<div class="text-center px-lg">
<p class="font-label-caps text-label-caps text-primary">MATCH VENUE</p>
<p class="font-h2 text-h2 text-on-surface">M. Chinnaswamy Stadium, Bengaluru</p>
</div>
</div>
<img alt="Stadium" class="w-full h-full object-cover" data-alt="An expansive wide-angle shot of a world-class cricket stadium at night, with towering floodlights casting a brilliant white and green glow over the lush field. The architecture is modern and imposing, with thousands of spectator seats creating a textured pattern in the background. The atmosphere is electric and celebratory, with a dark midnight sky framing the brightly lit arena in a broadcast-quality visual style." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBAJzAvz_v_9RSABKZmpmgDWgVHDGxu8XDw3VePf4HorOfLTCpOmPShu7FAZPMO0A1iYqMRbiabFyv7MdMZZ3SzMW4uh3P4YmH2sPwilF6ZJl1Zi-DFyWvted2osNKlwktsDS14ght4njvN63hJaiGZe-kMmH24aAboENy12mzS6yqRTrwymBAnjfYLhQ-Kc6bZrw1HCWvltB6Ms1F3kj9_bD_A_bPgXUP3SgH79SWaAS3JZQ0kXy4D8con-VNk5fJjpJ-fhBvYGoE"/>
</div>
</div>
</body></html>