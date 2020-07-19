Include %occInclude

/// %Installer Manifest ZFS.REST.Installer
Class ZFS.REST.Installer
{

/// マニフェスト定義.
XData RESTManifest [ XMLNamespace = INSTALLER ]
{
<Manifest>

<Namespace Name="USER" Create="no">
<Import File="${SRCDIR}/Test" Flags="ck" Recurse="1" />

</Namespace>

</Manifest>
}

/// これは XGL により生成されたメソッド・ジェネレーターです。.
ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
 #; XGL ドキュメントでこのメソッドのコードを生成する.
 Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "RESTManifest")
}

/// （サンプル）REST用ベースURL /crudSample　の設定（ディスパッチクラス：Test.VSCode.REST）　
ClassMethod RunInstall(dir As %String) As %Status
{
	#dim ex As %Exception.AbstractException
	set status=$$$OK
	try {
		set var("SRCDIR")=dir
		set status=..setup(.var)
		$$$THROWONERROR(ex,status)
		set webName = "/crudSample"
		set webProperties("DispatchClass") = "Test.VSCode.REST"
		set webProperties("NameSpace") = "USER"
		set webProperties("Enabled") = 1
		set webProperties("AutheEnabled") = 32
		set status = ##class(Security.Applications).Create(webName, .webProperties)
		$$$THROWONERROR(ex,status)
	}
	catch ex {
		set status=ex.AsStatus()
	}
	quit status
}

}
