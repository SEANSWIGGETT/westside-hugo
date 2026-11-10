param([Parameter(Mandatory)][string]$OutDir)
# Generates three animated SVG backdrop scenes for the Westside site.
$ErrorActionPreference = 'Stop'
$inv = [Globalization.CultureInfo]::InvariantCulture
function F([double]$v, [int]$d = 1) { [math]::Round($v, $d).ToString($inv) }
$utf8 = New-Object Text.UTF8Encoding $false
function Save($name, $svg) { [IO.File]::WriteAllText((Join-Path $OutDir $name), $svg, $utf8) }

$reduced = '@media (prefers-reduced-motion:reduce){*{animation:none!important}}'

# ---------------------------------------------------------------- 1. Sunrise over the three crosses
$r = New-Object Random 7
$rays = (0..17 | ForEach-Object { $a = $_ * 20; "<path d=`"M800 560L775 -700L825 -700Z`" transform=`"rotate($a 800 560)`"/>" }) -join ''
$motes = (1..22 | ForEach-Object {
  $x = 300 + $r.Next(1000); $y = 640 + $r.Next(220); $rad = F (1.5 + $r.NextDouble() * 2); $d = F (-$r.NextDouble() * 12)
  "<circle class=`"mote`" cx=`"$x`" cy=`"$y`" r=`"$rad`" style=`"animation-delay:${d}s`"/>"
}) -join ''
$dove = '<path d="M0 0C-14-4-26-2-34 6C-24 4-14 6-6 10C-2 16 6 18 14 16C20 15 26 11 30 6L40 4L31 1C26-4 18-6 10-4Z"/>'
$doves = (@(
  @{y=250; s=1.0; dur=34; del=0},
  @{y=200; s=.7; dur=42; del=-14},
  @{y=320; s=.55; dur=48; del=-30}
) | ForEach-Object {
  "<g class=`"fly`" style=`"animation-duration:$($_.dur)s;animation-delay:$($_.del)s`"><g transform=`"translate(0 $($_.y)) scale($($_.s))`">" +
  "<g class=`"wing`"><path d=`"M2 0C-6-30 -30-46-56-44C-36-30-22-14-12 2Z`"/></g>$dove" +
  "<g class=`"wing w2`"><path d=`"M8 2C10-26 26-48 52-56C40-36 30-18 20 4Z`"/></g></g></g>"
}) -join ''

$sunrise = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 900" width="1600" height="900" preserveAspectRatio="xMidYMid slice">
<style>
.rays{transform-box:view-box;transform-origin:800px 560px;animation:spin 140s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}
.sun{animation:breathe 7s ease-in-out infinite}
@keyframes breathe{50%{opacity:.75}}
.cloud{animation:drift 60s ease-in-out infinite alternate}
@keyframes drift{to{transform:translateX(180px)}}
.fly{animation:fly 36s linear infinite}
@keyframes fly{from{transform:translateX(-160px)}to{transform:translateX(1760px)}}
.wing{transform-box:fill-box;transform-origin:50% 100%;animation:flap .9s ease-in-out infinite alternate}
.w2{transform-origin:0 100%}
@keyframes flap{to{transform:scaleY(-.55)}}
.mote{fill:#ffe2a0;opacity:0;animation:rise 11s linear infinite}
@keyframes rise{12%{opacity:.85}75%{opacity:.5}100%{transform:translateY(-320px);opacity:0}}
$reduced
</style>
<defs>
<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#160f33"/><stop offset=".38" stop-color="#43296e"/><stop offset=".62" stop-color="#a5507a"/><stop offset=".8" stop-color="#ef8f45"/><stop offset="1" stop-color="#ffd27a"/></linearGradient>
<radialGradient id="glow" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#fff3c4" stop-opacity=".95"/><stop offset=".25" stop-color="#ffd27a" stop-opacity=".6"/><stop offset="1" stop-color="#ffb347" stop-opacity="0"/></radialGradient>
<linearGradient id="ray" x1="0" y1="1" x2="0" y2="0"><stop offset="0" stop-color="#fff0c0" stop-opacity=".22"/><stop offset="1" stop-color="#fff0c0" stop-opacity="0"/></linearGradient>
</defs>
<rect width="1600" height="900" fill="url(#sky)"/>
<g class="rays" fill="#ffe7a8" opacity=".09">$rays</g>
<circle class="sun" cx="800" cy="560" r="420" fill="url(#glow)"/>
<circle cx="800" cy="560" r="96" fill="#fff4cf"/>
<g fill="#fff" opacity=".13">
  <g class="cloud"><ellipse cx="260" cy="230" rx="170" ry="26"/><ellipse cx="330" cy="212" rx="90" ry="24"/></g>
  <g class="cloud" style="animation-delay:-25s"><ellipse cx="1180" cy="170" rx="210" ry="22"/><ellipse cx="1110" cy="155" rx="100" ry="22"/></g>
  <g class="cloud" style="animation-delay:-40s"><ellipse cx="700" cy="330" rx="150" ry="16"/></g>
</g>
<g fill="#f7efe0" opacity=".85">$doves</g>
<path d="M0 640Q260 560 520 610T1040 590T1600 620V900H0Z" fill="#3b2a55" opacity=".85"/>
<path d="M0 700Q400 560 800 600T1600 680V900H0Z" fill="#14504f"/>
<g fill="#0a2f2e">
  <rect x="790" y="410" width="20" height="200" rx="3"/><rect x="738" y="455" width="124" height="18" rx="3"/>
  <rect x="633" y="500" width="14" height="128" rx="2"/><rect x="598" y="530" width="84" height="12" rx="2"/>
  <rect x="953" y="500" width="14" height="128" rx="2"/><rect x="918" y="530" width="84" height="12" rx="2"/>
</g>
<path d="M0 760Q300 660 640 720T1300 700T1600 740V900H0Z" fill="#0b3d3c"/>
<path d="M0 830Q420 760 860 810T1600 800V900H0Z" fill="#072a29"/>
<g>$motes</g>
</svg>
"@
Save 'sunrise.svg' $sunrise

# ---------------------------------------------------------------- 2. Sanctuary with stained glass
$r = New-Object Random 11
$cols = '#19b3ae','#7a4fc0','#f6b92b','#d4577a','#3b7fd6','#2fbf71'
function Window($cx, $w, $top, $h, $id) {
  $x0 = $cx - $w / 2; $rad = $w / 2
  $shape = "M$x0 $($top + $h)V$($top + $rad)A$rad $rad 0 0 1 $($x0 + $w) $($top + $rad)V$($top + $h)Z"
  $cw = $w / 4; $ch = 46
  $panes = for ($yy = $top; $yy -lt $top + $h; $yy += $ch) { for ($xx = $x0; $xx -lt $x0 + $w; $xx += $cw) {
    $c = $cols[$r.Next($cols.Count)]; $d = F (-$r.NextDouble() * 8); $du = F (5 + $r.NextDouble() * 5)
    "<rect class=`"pane`" x=`"$(F $xx)`" y=`"$yy`" width=`"$(F ($cw+1))`" height=`"$($ch+1)`" fill=`"$c`" style=`"animation-delay:${d}s;animation-duration:${du}s`"/>"
  } }
  $lead = ((1..3 | ForEach-Object { "M$(F ($x0 + $_ * $cw)) $top V$($top + $h)" }) -join '') +
          ((0..([int]($h / $ch)) | ForEach-Object { "M$x0 $($top + $_ * $ch)H$($x0 + $w)" }) -join '')
  @{
    Def  = "<clipPath id=`"$id`"><path d=`"$shape`"/></clipPath>"
    Body = "<g clip-path=`"url(#$id)`">$($panes -join '')<path d=`"$lead`" stroke=`"#06110f`" stroke-width=`"5`" fill=`"none`"/>" +
           "<circle cx=`"$cx`" cy=`"$($top + $rad)`" r=`"$(F ($rad*.55))`" fill=`"none`" stroke=`"#06110f`" stroke-width=`"6`"/></g>" +
           "<path d=`"$shape`" fill=`"none`" stroke=`"#1a2d2c`" stroke-width=`"16`"/>"
  }
}
$wl = @((Window 800 240 120 440 'wc'), (Window 400 170 190 330 'wl'), (Window 1200 170 190 330 'wr'))
$winDefs = ($wl | ForEach-Object { $_.Def }) -join ''
$winBody = ($wl | ForEach-Object { $_.Body }) -join ''
$shafts = @"
<polygon class="shaft" points="680,560 920,560 1180,900 470,900" fill="url(#shaftG)"/>
<polygon class="shaft" points="315,520 485,520 640,900 230,900" fill="url(#shaftT)" style="animation-delay:-3s"/>
<polygon class="shaft" points="1115,520 1285,520 1370,900 960,900" fill="url(#shaftP)" style="animation-delay:-5s"/>
"@
$motes = (1..30 | ForEach-Object {
  $x = 300 + $r.Next(1000); $y = 640 + $r.Next(240); $rad = F (1.2 + $r.NextDouble() * 2.2); $d = F (-$r.NextDouble() * 14)
  "<circle class=`"mote`" cx=`"$x`" cy=`"$y`" r=`"$rad`" style=`"animation-delay:${d}s`"/>"
}) -join ''
function Candle($x, $h, $del) {
  "<rect x=`"$($x-9)`" y=`"$(700-$h)`" width=`"18`" height=`"$h`" rx=`"3`" fill=`"#efe4cf`"/>" +
  "<ellipse class=`"halo`" cx=`"$x`" cy=`"$(684-$h)`" rx=`"38`" ry=`"46`" fill=`"url(#flameGlow)`" style=`"animation-delay:${del}s`"/>" +
  "<path class=`"flame`" d=`"M$x $(668-$h)C$($x+9) $(680-$h) $($x+8) $(694-$h) $x $(698-$h)C$($x-8) $(694-$h) $($x-9) $(680-$h) $x $(668-$h)Z`" fill=`"#ffd27a`" style=`"animation-delay:${del}s`"/>"
}
$pews = (0..3 | ForEach-Object {
  $y = 760 + $_ * 46; $inset = 260 - $_ * 70
  "<rect x=`"$inset`" y=`"$y`" width=`"$(640 - $inset - 50)`" height=`"30`" rx=`"8`"/><rect x=`"$(850)`" y=`"$y`" width=`"$(640 - $inset - 50)`" height=`"30`" rx=`"8`"/>"
}) -join ''
$sanct = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 900" width="1600" height="900" preserveAspectRatio="xMidYMid slice">
<style>
.pane{opacity:.55;animation:shimmer 7s ease-in-out infinite}
@keyframes shimmer{50%{opacity:.95}}
.shaft{mix-blend-mode:screen;animation:shaft 9s ease-in-out infinite}
@keyframes shaft{50%{opacity:.55}}
.flame{transform-box:fill-box;transform-origin:50% 100%;animation:flicker .18s ease-in-out infinite alternate}
@keyframes flicker{to{transform:scale(.86,1.12) skewX(3deg)}}
.halo{animation:halo 2.6s ease-in-out infinite}
@keyframes halo{50%{opacity:.6}}
.cross{animation:breathe 6s ease-in-out infinite}
@keyframes breathe{50%{opacity:.7}}
.mote{fill:#ffe7b0;opacity:0;animation:rise 14s linear infinite}
@keyframes rise{10%{opacity:.8}80%{opacity:.4}100%{transform:translate(40px,-360px);opacity:0}}
$reduced
</style>
<defs>
<linearGradient id="wall" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#081a20"/><stop offset=".7" stop-color="#0d2a2c"/><stop offset="1" stop-color="#061314"/></linearGradient>
<linearGradient id="shaftG" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffd27a" stop-opacity=".35"/><stop offset="1" stop-color="#ffd27a" stop-opacity="0"/></linearGradient>
<linearGradient id="shaftT" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#19b3ae" stop-opacity=".3"/><stop offset="1" stop-color="#19b3ae" stop-opacity="0"/></linearGradient>
<linearGradient id="shaftP" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#a77be8" stop-opacity=".3"/><stop offset="1" stop-color="#a77be8" stop-opacity="0"/></linearGradient>
<radialGradient id="flameGlow" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#ffd27a" stop-opacity=".55"/><stop offset="1" stop-color="#ffd27a" stop-opacity="0"/></radialGradient>
<radialGradient id="crossGlow" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#ffd27a" stop-opacity=".5"/><stop offset="1" stop-color="#ffd27a" stop-opacity="0"/></radialGradient>
$winDefs
</defs>
<rect width="1600" height="900" fill="url(#wall)"/>
<path d="M120 900V200Q120 60 260 60H1340Q1480 60 1480 200V900" fill="none" stroke="#123534" stroke-width="12"/>
$winBody
$shafts
<rect x="0" y="700" width="1600" height="200" fill="#071a1a"/>
<ellipse class="cross" cx="800" cy="610" rx="150" ry="150" fill="url(#crossGlow)"/>
<g class="cross" fill="#f6c453"><rect x="790" y="540" width="20" height="150" rx="3"/><rect x="752" y="575" width="96" height="18" rx="3"/></g>
<rect x="640" y="690" width="320" height="22" rx="4" fill="#2a1d14"/><rect x="660" y="712" width="280" height="50" fill="#1d140e"/>
$(Candle 690 70 0)$(Candle 910 70 -0.7)$(Candle 560 50 -1.3)$(Candle 1040 50 -0.4)
<g>$motes</g>
<g fill="#040d0d" stroke="#173a38" stroke-width="2">$pews</g>
</svg>
"@
Save 'sanctuary.svg' $sanct

# ---------------------------------------------------------------- 3. Star over a country church
$r = New-Object Random 3
$stars = (1..120 | ForEach-Object {
  $x = $r.Next(1600); $y = $r.Next(560); $rad = F (0.6 + [math]::Pow($r.NextDouble(), 3) * 2.4)
  $d = F (-$r.NextDouble() * 6); $du = F (2.5 + $r.NextDouble() * 4)
  "<circle class=`"tw`" cx=`"$x`" cy=`"$y`" r=`"$rad`" style=`"animation-delay:${d}s;animation-duration:${du}s`"/>"
}) -join ''
$flies = (1..16 | ForEach-Object {
  $x = 100 + $r.Next(1400); $y = 740 + $r.Next(140); $d = F (-$r.NextDouble() * 9); $du = F (6 + $r.NextDouble() * 6)
  "<circle class=`"fly`" cx=`"$x`" cy=`"$y`" r=`"2.6`" style=`"animation-delay:${d}s;animation-duration:${du}s`"/>"
}) -join ''
$night = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 900" width="1600" height="900" preserveAspectRatio="xMidYMid slice">
<style>
.tw{fill:#fff;animation:tw 4s ease-in-out infinite}
@keyframes tw{50%{opacity:.2}}
.star{transform-box:fill-box;transform-origin:50% 50%;animation:pulse 5s ease-in-out infinite}
@keyframes pulse{50%{transform:scale(.88);opacity:.8}}
.spin{transform-box:view-box;transform-origin:1120px 190px;animation:spin 90s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}
.beam{animation:beam 8s ease-in-out infinite}
@keyframes beam{50%{opacity:.45}}
.shoot{opacity:0;animation:shoot 13s ease-in infinite}
@keyframes shoot{0%,86%{opacity:0;transform:translate(0,0)}88%{opacity:1}96%{opacity:0;transform:translate(-520px,260px)}100%{opacity:0}}
.win{animation:win 3.4s ease-in-out infinite}
@keyframes win{50%{opacity:.7}}
.fly{fill:#ffe27a;animation:wander 8s ease-in-out infinite alternate}
@keyframes wander{0%{transform:translate(0,0);opacity:.2}50%{opacity:1}100%{transform:translate(30px,-26px);opacity:.3}}
$reduced
</style>
<defs>
<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#040a1c"/><stop offset=".55" stop-color="#0c2140"/><stop offset=".85" stop-color="#16465a"/><stop offset="1" stop-color="#1d5c62"/></linearGradient>
<radialGradient id="sg" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#fff6d8" stop-opacity=".9"/><stop offset=".2" stop-color="#ffd27a" stop-opacity=".45"/><stop offset="1" stop-color="#ffd27a" stop-opacity="0"/></radialGradient>
<linearGradient id="bm" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffe7a8" stop-opacity=".22"/><stop offset="1" stop-color="#ffe7a8" stop-opacity="0"/></linearGradient>
<linearGradient id="tail" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#fff" stop-opacity="1"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient>
<radialGradient id="wg" cx=".5" cy=".5" r=".5"><stop offset="0" stop-color="#ffcf6a" stop-opacity=".6"/><stop offset="1" stop-color="#ffcf6a" stop-opacity="0"/></radialGradient>
</defs>
<rect width="1600" height="900" fill="url(#sky)"/>
<g>$stars</g>
<g class="shoot"><path d="M1380 90L1520 30" stroke="url(#tail)" stroke-width="3" stroke-linecap="round" transform="rotate(180 1450 60)"/></g>
<polygon class="beam" points="1110,200 1130,200 1180,700 980,700" fill="url(#bm)"/>
<circle cx="1120" cy="190" r="190" fill="url(#sg)"/>
<g class="spin" fill="#fff1c8" opacity=".25"><path d="M1120 190L1114 -60L1126 -60Z"/><path d="M1120 190L1114 440L1126 440Z"/><path d="M1120 190L870 184L870 196Z"/><path d="M1120 190L1370 184L1370 196Z"/></g>
<path class="star" d="M1120 120L1132 178L1190 190L1132 202L1120 260L1108 202L1050 190L1108 178Z" fill="#fff6dc"/>
<path d="M0 660Q300 590 620 640T1200 610T1600 650V900H0Z" fill="#0d3540"/>
<path d="M0 730Q380 650 820 700T1600 720V900H0Z" fill="#0a2a30"/>
<g fill="#06181c">
  <rect x="1010" y="610" width="180" height="110"/><path d="M1000 612L1100 548L1200 612Z"/>
  <rect x="1060" y="520" width="44" height="100"/><path d="M1054 522L1082 440L1110 522Z"/>
  <rect x="1079" y="404" width="6" height="40"/><rect x="1068" y="414" width="28" height="6"/>
</g>
<ellipse class="win" cx="1100" cy="672" rx="120" ry="60" fill="url(#wg)"/>
<g class="win" fill="#ffcf6a"><rect x="1032" y="640" width="20" height="34" rx="10"/><rect x="1148" y="640" width="20" height="34" rx="10"/><rect x="1086" y="660" width="28" height="60" rx="14"/><circle cx="1082" cy="560" r="9"/></g>
<path d="M0 800Q420 730 900 780T1600 790V900H0Z" fill="#061c20"/>
<path d="M640 900Q900 820 1100 722" stroke="#0f3a3e" stroke-width="26" fill="none"/>
<g>$flies</g>
</svg>
"@
Save 'night.svg' $night
Get-ChildItem $OutDir | Select-Object Name, Length
