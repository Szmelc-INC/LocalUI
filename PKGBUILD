# Maintainer: SilverX <serainox@gmail.com>
pkgname=localui-git
_repo=LocalUI
pkgver=r0.0000000
pkgrel=1
pkgdesc="Tiny PHP/JS local web UI that renders controls from JSON config and drives the OS via shell"
arch=('any')
url="https://github.com/Szmelc-INC/LocalUI"
license=('MIT')
depends=('bash' 'php')
makedepends=('git')
optdepends=('xdg-utils: localui --open'
            'chromium: browser/webkiosk.sh kiosk mode'
            'firefox: browser/webkiosk.sh kiosk mode')
provides=('localui')
conflicts=('localui')
source=("git+$url.git")
sha256sums=('SKIP')

pkgver() {
  cd "$_repo"
  ( set -o pipefail
    git describe --long --tags --abbrev=7 2>/dev/null | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g' ||
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)" )
}

check() {
  cd "$_repo"
  for f in $(find api lib public -name '*.php'); do php -l "$f" >/dev/null; done
}

package() {
  cd "$_repo"
  install -d "$pkgdir/usr/share/localui"
  cp -r api lib public browser config "$pkgdir/usr/share/localui/"
  install -Dm755 bin/localui "$pkgdir/usr/bin/localui"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
  install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
}
