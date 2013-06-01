# === [*version*]
#
# The version of PE to stage
#
# === [*installer*]
#
# The name of the installer, without an extension
#
# * example: 'puppet-enterprise-2.5.3-el-5'
#
# === [*download_dir*]
#
# The remote directory to download the installer from. Should not contain the
# version of PE as a directory component.
#
# * example: 'https://my.site.downloads/puppet-enterprise'

class pe_upgrade::staging(
  $version,
  $installer,
  $download_dir,
  $timeout,
) {

  include '::staging'

  $ext = $::pe_upgrade_extension
  $installer_pkg = "${installer}.${ext}"

  $source_url = regsubst("${download_dir}/${version}/${installer_pkg}", ':version', $version)

  #if $checksum {
  #  # Remove failed staging attempts. Nominally this should be in
  #  # the staging module.
  #  exec { "Remove installer tarball with invalid checksum":
  #    command => "rm ${staging_root}/${installer_tar}",
  #    path    => "/usr/bin:/bin",
  #    onlyif  => "test `md5sum ${installer_tar}` != ${checksum}",
  #    before  => Staging::File[$installer_tar],
  #  }
  #}

  staging::file { $installer_pkg:
    source  => $source_url,
    timeout => $timeout,
  }


  $staging_root = $pe_upgrade::staging_root
  staging::extract { $installer_pkg:
    target  => $staging_root,
    require => Staging::File[$installer_tar],
  }
}
