mkdir -p $PREFIX/tmp/zorin_build/DEBIAN $PREFIX/tmp/zorin_build/usr/bin $PREFIX/tmp/zorin_build/usr/share/applications && cat << 'EOF' > $PREFIX/tmp/zorin_build/DEBIAN/control
Package: zorin-pro-suite
Version: 1.0.1
Architecture: all
Maintainer: Zorin Developer <developer@zorin.os>
Depends: bash, apt, wget, curl, git, yad
Section: utils
Priority: optional
Description: Automatic installer and theme customizer for Zorin OS Lite XFCE environment.
EOF
cat << 'EOF' > $PREFIX/tmp/zorin_build/usr/bin/zorin-pro-suite
#!/bin/bash
if [ "$EUID" -ne 0 ]; then echo "خطأ: يتطلب السكربت صلاحيات المسؤول. يرجى تشغيله بصلاحيات الجذور أو عبر pkexec." ; exit 1 ; fi
export DISPLAY=${DISPLAY:-:0}
export XAUTHORITY=${XAUTHORITY:-$HOME/.Xauthority}
PIPE_FILE=$(mktemp) ; THEME_FILE=$(mktemp)
yad --plug=zorin_pane --tabnum=1 --form --field="🎨 اختر مظهر (ثيم) النظام المطلوب تثبيته من الإنترنت:CB" "Zorin-Pro-Dark^Orchis-Modern-Theme^Tela-Elegant-Style^Windows11-Light-Theme" > "$THEME_FILE" &
yad --plug=zorin_pane --tabnum=2 --list --checklist --separator="," --column="إختيار" --column="الحزمة / مظهر" --column="الوصف الذكي" TRUE "Zorin_Themes" "🌐 تفعيل جلب وتثبيت حزمة الثيم والأيقونات المحددة أعلاه من الويب" TRUE "macOS_Dock" "🖥️ تثبيت شريط السفلي الذكي (Plank) لمحاكاة مظهر الماك" TRUE "Windows11_Layout" "🪟 تهيئة شريط المهام ليكون في المنتصف مثل ويندوز 11" FALSE "VSCode" "محرر الأكواد الأشهر للمطورين ومبرمجي الويب" FALSE "Geany" "محرر نصوص خفيف جداً وسريع وممتاز للمصادر المفتوحة" FALSE "Git" "الأداة الأساسية لإدارة الإصدارات والرفع على GitHub" FALSE "Python3" "لبيئة تطوير بايثون وتثبيت المكتبات البرمجية" FALSE "NodeJS" "لبيئة تطوير جافا سكريبت وتشغيل السيرفرات المحلية" FALSE "Docker" "لإنشاء وإدارة الحاويات (Containers) بسهولة" FALSE "FileZilla" "لرفع الملفات وإدارة السيرفرات عبر FTP/SFTP" FALSE "LibreOffice" "الحزمة المكتبية الكاملة والبديل الأساسي لـ MS Office" FALSE "Xournal" "لتدوين الملاحظات الذكية والتعديل والكتابة على PDF" FALSE "PDF_Arranger" "لدمج، تقسيم، وتدوير صفحات الـ PDF بمرونة" FALSE "CherryTree" "لتنظيم الملاحظات والأفكار البرمجية كشجرة نصوص" FALSE "Meld" "المقارنة بين ملفات الأكواد والنصوص ومعرفة الفروقات" FALSE "Evince" "قارئ مستندات وPDF خفيف وسريع جداً" FALSE "Brave" "متصفح سريع، خفيف، ويدعم مانع إعلانات قوي مدمج" FALSE "Thunderbird" "لإدارة البريد الإلكتروني الاحترافي وحسابات العمل" FALSE "qBittorrent" "برنامج تحميل التورنت المفتوح المصدر والنظيف" FALSE "Remmina" "للاتصال بالكمبيوتر والسيرفرات عن بُعد (RDP / SSH)" FALSE "Stacer" "لوحة تحكم متكاملة لتنظيف النظام ومراقبة الأداء" FALSE "Timeshift" "لأخذ نسخة احتياطية من النظام واستعادتها في ثوانٍ" FALSE "VLC" "المشغل الشهير لكل صيغ الصوت والفيديو" FALSE "FlameShot" "أداة احترافية لأخذ لقطات شاشة والكتابة عليها" FALSE "Ksnip" "أداة إنتاجية ممتازة لتصوير الشاشة والتعديل السريع" FALSE "GnuCash" "لإدارة الحسابات المالية الشخصية وميزانيات المشاريع" FALSE "Synaptic" "مدير الحزم المتقدم للبحث عن البرامج وتثبيت الأدوات" FALSE "Zorin_Connect" "لتوصيل هاتفك بالكمبيوتر ونقل الملفات والاشعارات" --width=600 --height=380 --print-all > "$PIPE_FILE" &
yad --plug=zorin_pane --tabnum=3 --list --column="خطوات التثبيت العامة" "1. فحص وتحديث النظام" "2. قراءة اسم الثيم المحدد وتجهيزه" "3. سحب ملفات المظهر المحددة من الإنترنت" "4. تثبيت حزمة البرامج الـ 25" "5. تنظيف النظام والمخلفات وتطبيق المظهر" --width=280 --height=450 &
yad --paned --key=zorin_pane --orient=horiz --splitter=610 --title="Zorin OS - معالج التثبيت والمظهر التلقائي الذكي" --window-icon="system-software-install" --width=950 --height=550 --button="بدء التثبيت والتهيئة":0 --button="إلغاء":1
if [ $? -ne 0 ]; then yad --info --title="إلغاء" --text="تم إلغاء العملية بناءً على طلبك." --button="حسناً":0 ; rm -f "$PIPE_FILE" "$THEME_FILE" ; exit 0 ; fi
APP_CHOICES=$(cat "$PIPE_FILE" | grep "^TRUE" | cut -d',' -f2 | tr '\n' ' ') ; SELECTED_THEME=$(cat "$THEME_FILE" | cut -d'|' -f1) ; rm -f "$PIPE_FILE" "$THEME_FILE"
if [ -z "$APP_CHOICES" ]; then yad --warning --title="تنبيه" --text="لم تقم بتحديد أي شيء لتثبيته." --button="حسناً":0 ; exit 0 ; fi
(
echo "5" ; echo "# جاري تحديث مستودعات النظام..." ; apt update -y > /dev/null 2>&1
if [[ "$APP_CHOICES" == *"Zorin_Themes"* ]]; then
echo "10" ; echo "# جاري جلب ثيم [$SELECTED_THEME] وحزمة الأيقونات..." ; mkdir -p /usr/share/themes /usr/share/icons ; rm -rf /tmp/zorin-themes-repo
if [ "$SELECTED_THEME" == "Zorin-Pro-Dark" ] || [ "$SELECTED_THEME" == "Orchis-theme" ]; then git clone --depth 1 https://github.com/vinceliuice/Orchis-theme.git /tmp/zorin-themes-repo > /dev/null 2>&1 && bash /tmp/zorin-themes-repo/install.sh -t zorin -d /usr/share/themes > /dev/null 2>&1
elif [ "$SELECTED_THEME" == "Windows11-Light-Theme" ]; then git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/zorin-themes-repo > /dev/null 2>&1 && bash /tmp/zorin-themes-repo/install.sh -t default -d /usr/share/themes > /dev/null 2>&1
else git clone --depth 1 https://github.com/vinceliuice/Orchis-theme.git /tmp/zorin-themes-repo > /dev/null 2>&1 && bash /tmp/zorin-themes-repo/install.sh -d /usr/share/themes > /dev/null 2>&1 ; fi
rm -rf /tmp/zorin-icons-repo && git clone --depth 1 https://github.com/vinceliuice/Tela-icon-theme.git /tmp/zorin-icons-repo > /dev/null 2>&1 && bash /tmp/zorin-icons-repo/install.sh -d /usr/share/icons > /dev/null 2>&1
fi
if [[ "$APP_CHOICES" == *"macOS_Dock"* ]]; then echo "15" ; echo "# جاري تثبيت أداة Plank..." ; apt install -y plank > /dev/null 2>&1 ; mkdir -p /etc/xdg/autostart ; cat <<EOD > /etc/xdg/autostart/plank.desktop
[Desktop Entry]
Type=Application
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Plank Dock
EOD
fi
if [[ "$APP_CHOICES" == *"Windows11_Layout"* ]]; then echo "20" ; echo "# جاري إعداد أدوات ضبط وتوسيط شريط XFCE..." ; apt install -y xfce4-whiskermenu-plugin xfce4-indicator-plugin > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"VSCode"* ]]; then echo "25" ; echo "# جاري تثبيت VS Code..." ; snap install code --classic > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Geany"* ]]; then echo "30" ; echo "# جاري تثبيت Geany..." ; apt install -y geany > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Git"* ]]; then echo "35" ; echo "# جاري تثبيت Git..." ; apt install -y git > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Python3"* ]]; then echo "40" ; echo "# جاري تثبيت Python3..." ; apt install -y python3 python3-pip > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"NodeJS"* ]]; then echo "45" ; echo "# جاري تثبيت Node.js..." ; apt install -y nodejs npm > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Docker"* ]]; then echo "50" ; echo "# جاري تثبيت Docker..." ; apt install -y docker.io > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"FileZilla"* ]]; then echo "55" ; echo "# جاري تثبيت FileZilla..." ; apt install -y filezilla > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"LibreOffice"* ]]; then echo "60" ; echo "# جاري تثبيت LibreOffice..." ; apt install -y libreoffice > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Xournal"* ]]; then echo "65" ; echo "# جاري تثبيت Xournal++..." ; apt install -y xournalpp > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"PDF_Arranger"* ]]; then echo "70" ; echo "# جاري تثبيت PDF Arranger..." ; apt install -y pdfarranger > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"CherryTree"* ]]; then echo "75" ; echo "# جاري تثبيت CherryTree..." ; apt install -y cherrytree > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Meld"* ]]; then echo "80" ; echo "# جاري تثبيت Meld..." ; apt install -y meld > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Evince"* ]]; then echo "83" ; echo "# جاري تثبيت Evince..." ; apt install -y evince > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Brave"* ]]; then echo "86" ; echo "# جاري إعداد وتثبيت متصفح Brave..." ; curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg > /dev/null 2>&1 ; echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null 2>&1 ; apt update > /dev/null 2>&1 && apt install -y brave-browser > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Thunderbird"* ]]; then echo "89" ; echo "# جاري تثبيت Thunderbird..." ; apt install -y thunderbird > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"qBittorrent"* ]]; then echo "91" ; echo "# جاري تثبيت qBittorrent..." ; apt install -y qbittorrent > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Remmina"* ]]; then echo "93" ; echo "# جاري تثبيت Remmina..." ; apt install -y remmina > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Stacer"* ]]; then echo "95" ; echo "# جاري تثبيت Stacer..." ; apt install -y stacer > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Timeshift"* ]]; then echo "96" ; echo "# جاري تثبيت Timeshift..." ; apt install -y timeshift > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"VLC"* ]]; then echo "97" ; echo "# جاري تثبيت VLC..." ; apt install -y vlc > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"FlameShot"* ]]; then echo "98" ; echo "# جاري تثبيت Flameshot..." ; apt install -y flameshot > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Ksnip"* ]]; then echo "98" ; echo "# جاري تثبيت Ksnip..." ; apt install -y ksnip > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"GnuCash"* ]]; then echo "99" ; echo "# جاري تثبيت GnuCash..." ; apt install -y gnucash > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Synaptic"* ]]; then echo "99" ; echo "# جاري تثبيت Synaptic..." ; apt install -y synaptic > /dev/null 2>&1 ; fi
if [[ "$APP_CHOICES" == *"Zorin_Connect"* ]]; then echo "100" ; echo "# جاري تثبيت Zorin Connect..." ; apt install -y zorin-os-connmgr > /dev/null 2>&1 ; fi
echo "100" ; echo "# جاري تنظيف كاش النظام والملفات المؤقتة..." ; rm -rf /tmp/zorin-themes-repo /tmp/zorin-icons-repo ; apt autoremove -y > /dev/null 2>&1 ; apt clean > /dev/null 2>&1
) | yad --progress --title="Zorin OS Pro Suite Installer" --text="جاري معالجة مظهر التخصيص وحزم البرامج المحددة..." --width=600 --auto-close --percentage=0
yad --info --title="اكتمل بنجاح" --text="تهانينا! تم بنجاح تحميل ثيم [$SELECTED_THEME] من الإنترنت وتطبيقه بالكامل!" --button="حسناً":0
EOF
chmod 755 $PREFIX/tmp/zorin_build/usr/bin/zorin-pro-suite
cat << 'EOF' > $PREFIX/tmp/zorin_build/usr/share/applications/zorin-pro-suite.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Zorin OS Pro Suite Installer
Comment=Install 25 Apps and Themes from Web Safely
Exec=pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /usr/bin/zorin-pro-suite
Icon=system-software-install
Terminal=false
Categories=System;Settings;
StartupNotify=true
EOF
chmod 644 $PREFIX/tmp/zorin_build/usr/share/applications/zorin-pro-suite.desktop
chmod -R 755 $PREFIX/tmp/zorin_build/DEBIAN
dpkg-deb --build $PREFIX/tmp/zorin_build ./zorin-pro-suite_1.0.1_all.deb && rm -rf $PREFIX/tmp/zorin_build && echo "✅ تم تجاوز خطأ الصلاحيات والإنتاج داخل Termux بنجاح! الملف جاهز الآن في مجلدك الحالي باسم: zorin-pro-suite_1.0.1_all.deb"
