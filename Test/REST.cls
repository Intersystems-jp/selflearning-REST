/// 　手動によるRESTディスパッチクラス（中のコードはTest.VSCode.RESTと同様です）
Class Test.REST Extends %CSP.REST [ Language = objectscript ]
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/person/all" Method="GET" Call="GetAllPerson" Cors="true"/>
<Route Url="/person/:id" Method="GET" Call="GetPerson" Cors="true"/>
<Route Url="/person" Method="POST" Call="CreatePerson" Cors="true"/>
<Route Url="/person/:id" Method="PUT" Call="UpdatePerson" Cors="true"/>
<Route Url="/person/:id" Method="DELETE" Call="DeletePerson" Cors="true"/>
</Routes>
}

/// GET要求：全件取得例
ClassMethod GetAllPerson() As %Status
{
    set status=$$$OK
    try {
        //Person全件取得のためのコード
        set sql="select JSON_OBJECT('Name':Name,'Email':Email ABSENT ON NULL) as json from Test.Person"
        set stmt=##class(%SQL.Statement).%New()
        set status=stmt.%Prepare(sql)
        set rset=stmt.%Execute()
        set root=[]
        while rset.%Next() {
            set obj={}.%FromJSON(rset.%Get("json"))
            do root.%Push(obj)
        }
        //JSONをHTTPに出力
        do root.%ToJSON()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// POST要求：Test.Person（1件）の新規作成
ClassMethod CreatePerson() As %Status
{
    set status=$$$OK
    try {
        //JSON文字列からTest.Personのインスタンスへ変換
        set person=##class(Test.Person).%New()
        set status=person.%JSONImport(%request.Content.Read())
        $$$ThrowOnError(person.%Save())
    }
    Catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// GET要求：IDを指定した取得例
ClassMethod GetPerson(id As %Integer) As %Status
{
    set status=$$$OK
    try {
        //指定IDのPersonをオープン
        set person=##class(Test.Person).%OpenId(id)
        do person.%JSONExport()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// PUT要求：IDを指定してTest.Personを編集
ClassMethod UpdatePerson(id As %Integer) As %Status
{
    set status=$$$OK
    try {
        //変更対象のTest.Personをオープン
        set person=##class(Test.Person).%OpenId(id)
        set status=person.%JSONImport(%request.Content.Read())
        $$$ThrowOnError(person.%Save())
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// DELETE要求：1件IDを指定して削除
ClassMethod DeletePerson(id As %Integer) As %Status
{
    set status=$$$OK
    Try {
        $$$ThrowOnError(##class(Test.Person).%DeleteId(id)) 
    }
    Catch ex {
        set status=ex.AsStatus()
    }
    Return status
}

}
