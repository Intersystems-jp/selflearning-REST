Class Test.VSCode.REST Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/person/all" Method="GET" Call="GetAllPerson" Cors="true" />
<Route Url="/person" Method="POST" Call="CreatePerson" Cors="true" />
<Route Url="/person/:id" Method="GET" Call="GetPerson" Cors="true" />
<Route Url="/person/:id" Method="PUT" Call="UpdatePerson" Cors="true" />
<Route Url="/person/:id" Method="DELETE" Call="DeletePerson" Cors="true" />
</Routes>
}

/// DELETE要求：1件IDを指定して削除
ClassMethod DeletePerson(id As %Integer) As %Status
{
    set status=$$$OK
    Try {
        set %response.ContentType="application/json"
        set %response.CharSet="utf8"
        set status=##class(Test.Person).%DeleteId(id)

    } Catch ex {
        set status=ex.AsStatus()
    }
    
    return status
}

/// PUT要求：IDを指定してTest.Personを編集
ClassMethod UpdatePerson(id As %Integer) As %Status
{
    set status=$$$OK
    Try {
        set %response.ContentType="application/json"
        set %response.CharSet="utf8"
        set person=##class(Test.Person).%OpenId(id)
        set data=$ZConvert(%request.Content.Read(),"I","UTF8")
        set status=person.%JSONImport(data)
        set status=person.%Save()

    } Catch ex {
        set status=ex.AsStatus()
    }
    
    return status
}

/// GET要求：IDを指定した取得例
ClassMethod GetPerson(id As %Integer) As %Status
{
    set status=$$$OK
    Try {
        set %response.ContentType="application/json"
        set %response.CharSet="utf8"
        set person=##class(Test.Person).%OpenId(id)
        do person.%JSONExport()

    } Catch ex {
        set status=ex.AsStatus()
    }
    
    return status
}

/// POST要求：Test.Person（1件）の新規作成
ClassMethod CreatePerson() As %Status
{
    set status=$$$OK
    Try {
        set %response.ContentType="application/json"
        set %response.CharSet="utf8"
        set person=##class(Test.Person).%New()
        set data=$ZConvert(%request.Content.Read(),"I","UTF8")
        set status=person.%JSONImport(data)
        set status=person.%Save()
    } Catch ex {
        set status=ex.AsStatus()
    }
    
    return status
}

/// GET要求：全件取得例
ClassMethod GetAllPerson() As %Status
{
    set status=$$$OK
    Try {
        set %response.ContentType="application/json"
        set %response.CharSet="utf8"
        set sql="SELECT JSON_OBJECT('Name':Name,'Email':Email ABSENT ON NULL) as json from Test.Person"
        set stmt=##class(%SQL.Statement).%New()
        set status=stmt.%Prepare(sql)
        set rset=stmt.%Execute()
        set array=[]
        while rset.%Next() {
            set jobj={}.%FromJSON(rset.%Get("json"))
            do array.%Push(jobj)
        }
        do array.%ToJSON()

    } Catch ex {
        set status=ex.AsStatus()
    }
    
    return status
}

}
