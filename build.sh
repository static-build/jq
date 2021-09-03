

appname=jq

# apt-get install mingw-w64
# apt install gcc

build_main(){

    local rust_target=${1:?rust_target}
    local target_name=${2:?binary}
    local exe=${3:-${appname}}

    echo "Building $rust_target with $target_name"

    [ -f "bin/$target_name.7z" ] && return 0
    [ -f "bin/$target_name.7z.001" ] && return 0

    (
        cd bin && {

            p7z a "$target_name.7z" "$target_name"

            local size
            size="$(wc -c "$target_name.7z" | awk '{ print $1; }')"

            echo "------------\n$size"

            if [ "$size" -ge 1024000 ]; then
                rm "$target_name.7z"

                p7z -v970k a "$target_name.7z" "$target_name"
                xrc p7z
                p7z -v970k a "$target_name.7z" "$target_name"
                ls $target_name.7z* | wc -l | tr -cd '0-9' > "$target_name.7z"
            fi
            rm "$target_name"
        }
    )

}

main(){
    build_main x86_64-unknown-linux-musl ${appname}.linux.x64

    # build_main aarch64-unknown-linux-musl ${appname}.linux.arm64
    # build_main aarch64-unknown-linux-gnu ${appname}.linux.arm64

    # build_main armv7-unknown-linux-musleabi ${appname}.linux.armv7
    # build_main armv7-unknown-linux-musleabihf ${appname}.linux.armv7hf

    build_main aarch64-apple-darwin ${appname}.darwin.arm64
    build_main x86_64-apple-darwin ${appname}.darwin.x64

    build_main x86_64-pc-windows-gnu ${appname}.x64.exe
    # build_main aarch64-pc-windows-msvc ${appname}.arm64.exe ${appname}.exe
}

main

