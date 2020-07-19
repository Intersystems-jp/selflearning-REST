/// JSON用SQL関数の利用例
Class Test.JSONTest
{

/// 実行文（ターミナルなどで）：　do ##class(Test.JSONTest).GetAllPerson()
ClassMethod GetAllPerson()
{
    //埋込SQL
    &sql(declare C1 cursor for
         select JSON_OBJECT('Name':Name,'Email':Email) as json into :json
          from Test.Person)
    &sql(open C1)
    set array=[]
    for {
        &sql(fetch C1)
        if SQLCODE'=0 {
            quit
        }
        set obj={}.%FromJSON(json)
        do array.%Push(obj)
    }
    &sql(close C1)
    write array.%ToJSON()
}

/// 実行文（ターミナルなどで）：do ##class(Test.JSONTest).GetAllPersonArray()
ClassMethod GetAllPersonArray()
{
    set sql="SELECT JSON_ARRAY(Name,Email ABSENT ON NULL) as array from Test.Person"
    set stmt=##class(%SQL.Statement).%New()
    set status=stmt.%Prepare(sql)
    set rset=stmt.%Execute()
    set root=[]
    while rset.%Next() {
        set array=[].%FromJSON(rset.%Get("array"))
        do root.%Push(array)
    }
    do root.%ToJSON()
}

}
